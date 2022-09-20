// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

/**
 * @title IReferenceModule
 * @author Lens Protocol
 *
 * @notice This is the standard interface for all Lens-compatable ReferenceModules.
 */

interface IReferenceModuel {
    /**
     * @notice Initializes data for a given publication being published. This can only be called the hub.
     * @param profileId The token ID of the profile publishing the publication.
     * @param pubId The associated publication's LensHub publication ID.
     * @param data Arbitary data passed from the user to be decoded
     *
     * @return bytes An abi encoded byte array encapsulatin the execution's state changes. This will be emitted by the
     * hub alongside the collect module's address and should be consumed by front ends.
     */

    function initializeReferenceModule(
        uint256 profileId,
        uint256 pubId,
        bytes calldata data
    ) external returns (bytes memory);

    /**
     * @notice Process a comment action referencing a given publication. This can only be called by the hub.
     *
     * @param profileId The token ID of the profile associated with the publication being published
     * @param profileIdPointed The profile ID of the profile associated the publication being referenced.
     * @param pubIdPointed The publication ID of the publication being referenced.
     * @param data Arbitrary data __passed from the commenter!_ to be decoded.
     */

    function processComment(
        uint256 profileId,
        uint256 profileIdPointed,
        uint256 pubIdPointed,
        bytes calldata data
    ) external;

    /**
     * @notice Process a mirror action referencing a given publication. This can only be called by the hub.
     *
     *
     * @param profileId The token ID of the profile associated with the publication being publication being published.
     * @param profileIdPointed The profile ID of the profile associated the publication being referenced.
     * @param pubIdPointed The publication ID of the publication being referenced.
     * @param data Arbitarary data __passed from the mirrorer!__ to be decoded.
     */

    function processMirror(
        uint256 profileId,
        uint256 profileidPointed,
        uint256 pubIdPointed,
        bytes calldata data
    ) external;
}
