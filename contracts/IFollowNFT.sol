//SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {DataTypes} from "./DataTypes.sol";

/**
 * @title IFollowNFT
 * @author Lens Protocol
 *
 * @notice This is the interface for the FollowNFT conttact, which is cloned upon the first follow for any profile.
 *
 */

interface IFollowNFT {
    /**
     * @notice Initialize the follow NFT. setting the hub as the privileged minter and storing the associated profile ID.
     *
     * @param profileId The token ID of the profile in the hub associated with this followNFT, used for transfer hooks.
     */
    function initialize(uint256 profileId) external;

    /**
     * @notice Mints a follow NFT to the specific address. This can only be called by the hub, and is called upon follow.
     *
     * @param to The address to mint the NFT to.
     *
     * @return uint256 An integer representing the minted token ID
     */

    function mint(address to) external returns (uint256);

    /**
     * @notice Delegate the caller's governance power to the given delegateee address.
     * @param delegate The delegatee address to t delegate governance power to.
     *
     */

    function delegate(address delegate) external;

    /**
     * @notice Delegate the delegator's governance power via meta-tx to the given delegatee address.
     *
     * @param delegator The delegator address, who is the signer.
     * @param delegatee The delegatee address. who is reciving the governance power delegation.
     * @param sig The EIP712Signature struct containing the necessary parameters to recover the  `delegator`
     */

    function delegateBySig(
        address delegator,
        address delegatee,
        DataTypes.EIP712Signature calldata sig
    ) external;

    /**
     * @notice Returns the governance power for given user at a specifie block number.
     *
     * @param user The user to query governance power for.
     * @param blockNumber The block number to query the user's governance power at.
     * @return uint256 The power of the given user at the given blocknumer.
     */

    function getPowerByBlockNumber(address user, uint256 blockNumber)
        external
        returns (uint256);

    /**
     * @notice Returns the total delegated supply at a specific block number. The is the sum of all
     * current available voing power at a given block.
     *
     * @param blockNumber The block number to query the delegated supply at.
     *
     * @return uint256 The delegated supply at the given block number.
     */

    function getDelegatedSupplyByBlockNumber(uint256 blockNumber)
        external
        returns (uint256);
}
