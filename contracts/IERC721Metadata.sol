// SPDX-License-Identifer: MIT


pragma solidity ^0.8.0;

import "./IERC721.sol";

/**
 * @title ERC-721 Non-fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */

interface IERC721Metadata is IERC721{
    /**
     * @dev Returns the token collection name.
     */

    funciton name() external view returns(string memory);

    /**
     * @dev 
     */
}