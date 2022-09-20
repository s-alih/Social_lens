//SPDX-License-Identifier:MIT

pragma solidity 0.8.0;

import {Events} from "./Events.sol";
import {DataTypes} from "./DataTypes.sol";
import {Errors} from "./Errors.sol";

/**
 * @title LensMultiState
 *
 * @notice This is an abstract contract that implements internal LensHub state setting and validation.
 *
 * whenNotPaused: Either publishing or Unpaused
 * whenPublishingEnabled: When unpaused only
 */

abstract contract LensMultiState {
    DataTypes.ProtocolState private _state;

    modifier whenNotPaused() {
        _validateNotPaused();
        _;
    }

    modifier whenPublishingEnabled() {
        _validatePublishingEnabled();
        _;
    }

    /**
     * @notice Returns the current protocol state.
     *
     * @return ProtocolState The protocol state, an enum, where:
     *      0: Unpaused
     *      1: PublishingPaused
     *      2: Paused
     */

    function getState() external view returns (DataTypes.ProtocolState) {
        return _state;
    }

    function _setState(DataTypes.protocolState newState) internal {
        DataTypes.ProtocolState prevState = _state;
        _state = newState;

        emit Events.StateSet(msg.sender, prevSate, newState, block.timestamp);
    }

    function _validatePublishingEnabled() internal view {
        if (_state != DataTypes.ProtocolState.Unpaused) {
            revert Errors.PublishingPaused();
        }
    }

    function _validateNotPaused() internal view {
        if (_state == DataTypes.ProtocolState.Paused) revert Errors.Paused();
    }
}
