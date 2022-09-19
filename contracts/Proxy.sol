//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

/**
 * @dev This abstract contract provides a fallback function that delegate all call to another using using EVM
 * instruction `delegatecall`. we refer to the second contract as the implementation_ behind the proxy, and it has to
 * be specified by overriding the virtual {_implementation} function.
 *
 *
 * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a different contract
 * through the {_delegate} function.
 *
 * The success and return data of the delegate call will be returned back to the caller of the proxy
 */

abstract contract Proxy {
    /**
     * @dev Delegates the current call to `implementation`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */

    function _delegate(address implementation) internal virtual {
        assembly {
            // Copy msg.data. we take full control of memory in this inline assembly
            // block because it will not return to Solidity code. we overwrite the
            // Solidity scartch pad to memory position 0.

            calldatacopy(0, 0, calldatasize())

            //Call the implementaion
            // out and outside are 0 because we don't know the size yet.abi
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // copy the return data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    /**
     * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
     * and {_fallback} should delegate.
     */

    function _implementation() internal view virtual returns (address);

    /**
     * @dev Delegate the current call to this address returned by `_implementation()`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */

    function _fallback() internal virtual {
        _beforeFallback();
        _delegate(_implementation());
    }

    /**
     * @dev Fallback function that delegate calls to the address returned by `_implementation()`, will run if no other
     * function in the contract matches the call data
     */

    fallback() external payable virtual {
        _fallback();
    }

    /**
     * @dev Fallback function that delegates to the address returned by  `_implementation()`. Will run if call data
     * is empty
     */

    receive() external payable virtual {
        _fallback();
    }

    /**
     * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
     * call, or as part of the Solidity  `fallback` or  `receive` functions.
     *
     * If overriden should call `super._beforeFallback()`.
     */

    function _beforeFallback() internal virtual {}
}
