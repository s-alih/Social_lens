//SPDX-License-Identifer: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title IERC721Time
 * @author Lens Protocol
 *
 * @notice this is an expansion of the IERC721 interface that includes a struct for token data,
 * which contains the token owner and the mint timestamp as well as associated getter.
 */

interface IERC721Time is IERC721 {
    /**
     * @notice Contains the owner address and mint timestamp for every NFT
     *
     * NOTE: Instead og yhr owner address in the _tokenOwners private mapping we store it in the
     * _tokenData mapping alongside the unchanging mintTimestamp
     *
     * @param owner The token owner
     * @param mintTimestamp the mint timestamp
     *
     */

    struct TokenData {
        address owner;
        uint96 mintTimestamp;
    }

    /**
     * @notice Returns the mint timestamp associalted with a given NFT, stored only once upon inital mint
     *
     * @param tokenId the token ID of the NFT to query the mint timestamp for.
     *
     * @return uint256 mint timestamp. this is stored as a uint96 but returned as uint256 to reduce unnecessary padding
     */

    function mintTimestamp(uint256 tokenId) external view returns (uint256);

    /**
     * @notice Returns the token data associated with a given NFT. This allows fetching the token owner and
     * mint timestamp in a single call
     *
     * @param tokenId The token ID of the NFT to query the token data for
     *
     * @return TokenData token data struct containing both owner address and the mint timestamp.
     */

    function tokenDataOf(uint256 tokenId)
        external
        view
        returns (TokenData memory);

    /**
     * @notice Returns whether a token with the given token ID exists.
     *
     * @param tokenId the token ID of the NFT to check existence for.
     *
     * @return bool True if the token exists.
     */

    function exists(uint256 tokenId) external view returns (bool);
}
