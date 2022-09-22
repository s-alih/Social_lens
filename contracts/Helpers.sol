//SPDX-License-Identifier:MIT

pragma solidity 0.8.10;

import {DataTypes} from "./DataTypes.sol";
import {Erros} from "./Errors.sol";

/**
 * @title Helpers
 * @author Lens Protocol
 *
 * @notice This is a library that only contain a single function this is used in the hub contract as well as in
 * both the publishing logic and interaction logic
 */

library Helpers {
    /**
     * @notice This helper function just returns the ponted publication if the passed is a mirror
     */

    function getPointedIfMirror(
        uint256 profileId,
        uint256 pubId,
        mapping(uint256 => mapping(uint256 => DataTypes.PublicationStruct))
            storage _pubByIdByProfile
    )
        internal
        view
        returns (
            uint256,
            uint256,
            address
        )
    {
        address collectModule = _pubByIdByProfile[profileId][pubId]
            .collectModule;
        if (collectModule != address(0)) {
            return (profileId, pubId, collectModule);
        } else {
            uint256 pointedTokenId = _pubByIdByProfile[profileId][pubId]
                .profileIdPointed;
            // We validate existence here as an optimization, so validating in calling contracts is unnecessary
            if (pointedTokenId == 0) revert Errors.PublicationDoesNotExist();

            uint256 pointedPubId = _pubByIdByProfile[profileId][pubId]
                .pubIdPointed;

            address pointedCollectModule = _pubByIdByProfile[pointedTokenId][
                pointedPubId
            ].collectModule;

            return (pointedTokenId, pointedPubId, pointedCollectModule);
        }
    }
}
