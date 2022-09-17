//SPDX-License-Identifer: MIT
// OpenZeppelin Contracts v4.4.1

pragma solidity ^0.8.0;

import "./IERC165.sol";

/**
 * @dev Implemetation of the {IERC165} interface.
 *
 * Contracts that whant to implement ERC165 should inherit from this contract and overrid {supporsInterface} to check
 * for the additional interface id that will be supported. for example
 *
 *  ```solidity
 * function supportInterface(bytes4 interfaceId) public view virtual override returns(bool){
 *    return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId)
 * }
 *
 */

abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportInterface}.
     */

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return interfaceId == type(IERC165).interfaceId;
    }
}
