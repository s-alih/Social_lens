//SPDX-License-Identifer: MIT

pragma solidity ^0.8.0;

import "./IERC721Time.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension. but not including the Enumerable extension. which is available seperatly as
 * {ERC721Enumerable}.
 *
 * Modifications:
 * 1. Refactored _operatorApprovals setter into an internal function to allow meta-transactions.
 * 2. Constructors replaces with an intializer.
 * 3. Mint timestamp is now stored in a TokenData struct alongside the owner address
 */

abstract contract ERC721Time is Context, ERC165, IERC721Time, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to token Data (owner address and mint timestamp uint96), this
    // replaces the original mapping(uint256=>address) private _owners;

    mapping(uint256 => IERC721Time.TokenData) private _tokenData;

    // mapping owner addres to token coundt
    mapping(address => uint256) private _balance;

    // mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initialze the ERC721 name and symbol
     *
     * @param name The name to set
     * @param symbol the symbol to set
     */
    function _ERC721_Init(string calldata name, string calldata symbol)
        internal
    {
        _name = name;
        _symbol = symbol;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}
     */

    function balanceOf(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            owner != address(0),
            "ERC721: balance query for the zero address"
        );
        return _balance[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _tokenData[tokenId].owner;

        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }

    /**
     * @dev See {IERC721Time-mintTimeStampOf}
     */

    function mintTimestampOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (uint256)
    {
        uint96 mintTimestamp = _tokenData[tokenId].mintTimestamp;
        require(
            mintTimestamp != 0,
            "ERC721: mint timestamp query for nonexistent token"
        );

        return mintTimestamp;
    }

    /**
     * @dev See {IERC721Time-mintTimestampOf}
     */

    function tokenDataOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (IERC721Time.TokenData memory)
    {
        require(
            _exists(tokenId),
            "ERC721: token data query for nonexistent token"
        );

        return _tokenData[tokenId];
    }

    /**
     * @dev See {IERC721Time-exists}
     */

    function exists(uint256 tokenId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _exists(tokenId);
    }

    /**
     * @dev See {IERC721Metadata-name}
     */

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metada-symbol}.
     */

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * toke will be the concatenation of the `baseURI` and the `tokenId`.empty
     * by default, can be overriden in child contracts
     */

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}
     */

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721Time.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721:approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */

    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        require(operator != _msgSender(), "ERC721: approve to caller");
        _setOperatorApproval(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApproveedForAll}.
     */

    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev see {IERC721-transferFrom}
     */

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-diable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: tranfer caller is not owner nor approved"
        );
        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTranferFrom}.
     */

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev safely transfers `tokenId` token from  `from` to `to`, checking first that contract recipients
     * are aware fo the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has not specified format and it is sent in call to  `to`.
     *
     * This internal function is quivalent for {safeTransferFrom},  and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirments:
     *
     * -`from` cannot be the zero address
     * - `to` cannot be the zero address
     * - `tokenId` token must exist and be owned by `from`.
     * - If to refers to a smart contract, it must implement {IERC721Reciver-onERC721Recived}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);

        require(
            _checkOnERC721Recived(from, to, tokenId, _data),
            "ERC721: Transfer to non ERC721Reciver implementer"
        );
    }

    /**
     * @dev Returns whether `tokenId` exists
     *
     * Token can managed by their onwer or approved accounts via {approve} set {setApprovalForAll}.
     *
     * Token start existing jwhen they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _tokenData[tokenId].owner != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirments:
     *
     * - `tokenId` must exist.
     */

    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );

        address owner = ERC721Time.ownerOf(tokenId);

        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirments
     * - `tokenId` must not exist.
     * - If `to` refers to a smart conract, it must implement {IERC721Reciver-onERC721Recived}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`]. with an additional `data` parameter which is
     * forwarded in {ERC721Reciver-onERC721Recived} to contract recipients.
     */

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Recived(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Reciver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage ot this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirments:
     *
     * -  `tokenId` must not exist.
     * -   `to` cannot be the zero addrss .
     *
     * Emits a {tranfer} event,
     */

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);
        _balance[to] += 1;
        _tokenData[tokenId].owner = to;
        _tokenData[tokenId].mintTimestamp = uint96(block.timestamp);

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when token is burned.
     *
     * Requirments:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721Time.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // clear approvals
        _approve(address(0), tokenId);

        _balance[owner] -= 1;

        delete _tokenData[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     * As opposed to {transferFrom}. this imposes no restrictions on msg.sender
     *
     *
     * Requirments;
     *
     * - `to` cannot be the zero address
     * - `tokenId` token must be owneed by `from`.
     *
     * Emits a {Transfer event}.
     */

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC721Time.ownerOf(tokenId) == from,
            "ERC721: transfer of token that is not own"
        );
        require(to != address(0), "ERC721: transfer to the zero address ");

        _beforeTokenTransfer(from, to, tokenId);

        // clear approvals from the previous owner

        _approve(address(0), tokenId);

        _balance[from] -= 1;
        _balance[to] += 1;
        _tokenData[tokenId].owner = to;
    }

    /**
     * @dev Approve `to` to operator on `tokenId`
     *
     * Emites a {Approval} event
     */

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals(tokenId) = to;
        emit Approval(ERC721Time.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Refactored from the original OZ ERC721 implementaion: approve or revoke approval for  `operator` to operate on all tokens owned by `owner`.
     *
     * Emits a {ApprovalforAll} Events.
     */

    function _setOperatorApproval(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        _operatorApprovals[owner][operator] = approved;

        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Private function to invoke {IERC721Reciver-onERC721Recived} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will recieve the tokens
     * @param tokenId uint256 ID of the token to be transfered
     * @param _data bytes optional data to send along with call
     * @return bool whether the correctly returned the expected magic value
     */

    function _checkOnERC721Recived(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Reciver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning
     *
     * Calling conditions:
     *
     * -When `from` and `to` are both non-zero ``from``'s `tokenId` will be
     * transfered to `to`.
     *
     * - when `from` is zero `tokenId` will be minted for `to`.
     * - when `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero
     */

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}
