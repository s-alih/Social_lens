// SPDX-License-Identifier; MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";

/**
 * @title ERC-721 Non-Fungible Token Standard. optional enumeration extensio
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */

interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns total amount of tokens stored by the contract.
     */

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owner by `owner` at given `index` of its token list
     * use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);

    /**
     * @dev Returns a token ID at a given  `index` of all the token stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens
     */

    function tokenByIdex(uint256 index) external view returns (uint256);
}
