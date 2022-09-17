// SPDX-License-Identifier:MIT
//Openzeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context. including the
 * sender of the transaction and its data. while these are generally available
 * via msg.sender and msg.data they should not be accessed in such a direct manner
 * since when dealing with meta-transaction the account sending and
 * paying for execution my not be the actual sender(as far as an application is concerned).
 *
 * This contract is only required for intermidate, library-like contracts.
 */

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
