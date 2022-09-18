// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

/**
 * @title ERC721 token reciever interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */

interface IERC721Reciver {
    /**
     * @dev Whenever an {IERC721} `tokenId` is transfered to this contract is via {ERC721-safeTranferFrom}
     * by `operator` from `from`, this function is called
     *
     *
     * It must return its solidity selectors to confirm the token transfere.
     * If any other value is returned or the interface is not implemented by the recipient
     *
     * The selector can be obtained in solidity with `IERC721.onERC721Recived.selector`
     */

    function onERC721Recived(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
