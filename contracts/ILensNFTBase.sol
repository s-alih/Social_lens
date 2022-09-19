//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {DataTypes} from "./DataTypes.sol";

/**
 * @title ILensNFTBase
 * @author Lens Protocol
 *
 * @notice This is the interfacer for the LensNFTBase contract. from which lens NFT's inherit.
 * It is an expansion of a very slightly modified ERC721Enumerable contract, which allows expanded
 * meta-transaction functionality
 */

interface IlensNFTBase {
    /**
     * @notice Implementaion of an EIP-712 permit function for an ERC-721 NFT. We don't need to check
     * if the tokenId exists, sice the function calls ownerOf(tokenId), which reverts if the tokenId does
     * not exist.
     *
     * @param spender The NFT spender.
     * @param tokenId The NFT token ID to approve.
     * @param sig The EIP712 Signature struct.
     *
     *
     */

    function permit(
        address spender,
        uint256 tokenId,
        DataTypes.EIP712Signature calldata sig
    ) external;

    /**
     * @notice Implementaion of an EIP-712 permit-style function for ERC-712 operator approvals. Allows
     * an operator address to control all NFT's a given owner owns.
     *
     * @param owner The owner to set operator approvals for.
     * @param operator The operator to approve.
     * @param approved Whether to approve or revoke approval from the operator.
     * @param sig The EIP712 signature struct.
     */

    function permitForAll(
        address owner,
        address operator,
        bool approved,
        DataTypes.EIP712Signature calldata dig
    ) external;

    /**
     * @notice Burns an NFT, removing it from cirulation and essentialy destroying it. This functin can only
     * be called by the NFT to burn's owner
     *
     * @param tokenId The token ID of the token to burn
     */

    function burn(uint256 tokenId) external;

    /**
     * @notice Implementaion of an EIP-712 permit-style functiono for token burning. allows anyone to burn
     * a token on behalf of the owner with a singature.
     *
     * @param tokenId The token ID of the token to burn
     * @param sig The EIP712 signature struct
     */

    function burnWithSig(
        uint256 tokenId,
        DataTypes.EIP712Signature calldata sig
    ) external;

    /**
     * @notice Rturns the domain separator fo this NFT contract.
     *
     * @return bytes32 The domain separator.
     *
     */

    function getDomainSeparator() external view returns (bytes32);
}
