// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC165.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to` .
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId`
     */

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 tokenId
    );

    /**
     * @dev Emitted when `owner` enables or diables (`approved`) `operator`
     */

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */

    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirments:
     *
     * - `tokenId` must exist
     */

    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirments
     *
     * -  `from` cannot be the zero address.
     * -  `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`
     * - If the caller is not `from`. it must be have allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refer to a smart contract, it must implement { IERC721Reciver-onERC721Recived}, which is called upon safe transfer
     *
     * Emits a {Transfer} event.
     */

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of the method is dicouraged, use {safeTransferFrom} whenever possible
     *
     * Requirments
     *
     * - `from` cannot be the zero address
     * - `to` cannot be zero address
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`. it must be approved to move this token either {approve} or {setApprovalForAll}
     *
     * Emits a {Transfer} event
     *
     *  */

    function tranferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when token is transferd
     *
     * Only a single account can approved at a time. so approving the zero address clears previous approvals
     *
     * Requirments
     *
     * -The caller must own the token or be an approved operator
     * - `tokenId` must exist
     *
     * Emits an {Approval} event.
     */

    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirments:
     *
     * - `tokenId` must exist
     */

    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller
     *
     * Requirments:
     *
     * - The  `operator` cannot be the caller
     *
     * Emits an {ApprovalForAll} event.
     */

    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all the assets of the `owner`.
     *
     * see {setApprovalForAll}
     */

    function isApprovalForAll(address owner, address operator)
        external
        view
        returns (bool);

    /**
     * @dev Safely transfers `tokenId` token form `from` to `to`.
     *
     * Requirments
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and owned by `from`
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForall}.
     * -If `to` refers to a smart contract, it must implement {IERC721Reciver-onERC721Recived} which is called upon a safe transfer
     *
     * Emits a {Transfer} event.
     */

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}
