//SPDX-License-Identifier:MIT

pragma solidity 0.8.0;

/**
 * @dev IcollectNFT
 * @author Lens Protocol
 *
 * @notice This the interface for the collectNFT contract. which is cloned upon the first for any given
 * publication
 */

interface ICollectNFT {
    /**
     * @notice Initializes the collect NFT, setting the feed as the privalleged minter, storing the publication pointer
     * and initializing the name and symbol in the LensNFTBase contract.
     *
     * @param profileId The token ID of the profile in the hub that this collectNFT points to.
     * @param pubId The profile publication ID in the hub that this collecNFT points to.
     * @param name The name to set for this NFT.
     * @param symbol The symbol to set for this NFT.
     */

    function initialize(
        uint256 profileId,
        uint256 pubId,
        string calldata name,
        string calldata symbol
    ) external;

    /**
     * @notice Mints a collect NFT to the specified address. This can only be called by the hub, and is called upon collection
     * @param to The address to mint the NFT to.
     * @return uint256 An integer representing the minted token ID.
     */
    function mint(address to) external returns (uint256);

    /**
     * @notice Returns the source publication pointer mapped to this collect NFT.
     *
     * @return tuple First the profile ID uint256, and second the pubId uint256.
     *
     */

    function getSourcePublicationPointer()
        external
        view
        returns (uint256, uint256);
}
