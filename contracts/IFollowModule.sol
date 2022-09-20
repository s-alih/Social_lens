// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

/**
 * @title IFollowModule
 * @author Lens Protocol
 *
 * @notice This is the standard interface for all Lens-compatible FollowModules.
 */

interface IFollowModule {
    /**
     * @notice Initializes a follow module for a given Lens profile. This can only be called by the hub contract.
     *
     * @param profileId The token ID of the profile to initialize this follow module for.
     * @param data Arbitarary data passed by the profile creator.
     *
     * @return bytes The encoded data to emit in the hub
     */

    function initializeFollowModule(uint256 profileId, bytes calldata data)
        external
        returns (bytes memory);

    /**
     * @notice Process a given follow, this can only be called from the LensHub contract.
     *
     * @param follower The follower address
     * @param profileId The token ID of the profile being followed
     * @param data Arbitrary data passed by the follower
     *
     */

    function processFollow(
        address follower,
        uint256 profileId,
        bytes calldata data
    ) external;

    /**
     * @notice This is a transfer hook that is called upon follow NFT transfer in  `beforeTokenTransfer`, This can
     * only be called from the lensHub contract.._
     *
     * NOTE: Special care are needed to be take here: It is possible that follow NFTs were issued before this module
     * was initialised if the profile's follow module was previously different, This transfer hook should take this
     * into consideration, especially when the module holds state associated with individual follow NFT
     *
     * @param profileId The token ID fo the profile associated with the follow NFT being transfered
     * @param from The address sending the follow NFT.
     * @param to to The address recieving the follow NFT.
     * @param followNFTTokenId The Token ID of the follow NFT being transferd
     */

    function followModuleTransferHook(
        uint256 profileId,
        address from,
        address to,
        uint256 followNFTTokenId
    ) external;

    /**
     * @notice This is the heloer function that could be used in conjunction with specific collect modules.
     *
     * NOTE: This function IS meant to replace a check on follower NFT ownership
     *
     * NOTE: It is assumed that not all collect modules are aware of the token ID to pass. In thies cases.
     *
     *
     * NOTE: It is assumed that not all collect modules are aware of the token ID to pass. In these cases.
     * this should receive a  `followNFTTokenId` of 0, which is impossible regardless.
     *
     * One example of a use case for this would be a subscription-based following system:
     *          1. The collect module:
     *              - Decode a follower NFT token ID form user-passed data
     *              - fetches the follow module from the hub.
     *              - Calls  `isFollowing` passing the profile ID, follower & follower thoken ID and checks it returned true.
     *          2. The follow module:
     *              - Validates the subscription status for the given NFT, reverting on an invalid subscription.
     * @param profileId The token ID of the profile to validate the follow for.
     * @param follower The follower address to validate the follow for.
     * @param followNFTTokenId The followNFT token ID to validate the follow for.
     *
     * @return true if the given address is following the given profile ID. false otherwise.
     */

    function isFollowing(
        uint256 profileId,
        address follower,
        uint256 followNFTTokenId
    ) external view returns (bool);
}
