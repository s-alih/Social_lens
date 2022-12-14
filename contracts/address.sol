//SPDX-License-Identifer: MIT

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */

library Address {
    /**
     * @dev Returns true if `account` is a contract
     *
     * [IMPORTANT]
     * ======
     *
     * If is unsafe to assume that an address fo which this function returns false is an external-owneed account (EOA) and not a contract
     *
     * Among others,  `isContract` will return false for the following
     * type of addresses:
     *
     * - an external-owned account
     * - an contract in construction
     * - an address where a contract will be created
     * - an address where a contract lived, but was destroyed
     *
     * =====
     *
     * [IMPORTANT]
     * =====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged, It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does ot provide security since it can be circumvented by calling from a contract
     * constructor.
     * ======
     */

    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for the conttractsw in construction, since the code is only stored at the end of the constructor execution

        return account.code.length > 0;
    }

    /**
     * @dev Replacment for Solidity's `transfer`: sends `amount` wei to `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increase the gas cost of certain
     * opcodes. possibly making contract go over the 2300 gas limit imposed by `transfer`, making them unable to recieve funds via
     * `transfer`. {sendValue} removes this limitation
     *
     * IMPORTANT: because control is transfered to `recipient`, care must be taken
     * to not create reentrancy vulnerablitie. consider using {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance > amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");

        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plan `call` is an unsafe replacment for a function call: ust this function instead.
     *
     * If `target` reverts with revert reason, it is bubbled up by this function (like regular solidity function calls)
     *
     * Returns the raw returned data. To convert to the expected return value.
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirments:
     *
     * - `target` must be contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-address-functionCall-address-bytes}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts
     *
     *
     * _Available since v3.1.
     */

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes}[`functionCall`],
     * but also transfering `value` wei to `target`.
     *
     * Requirments:
     *
     * - the calling contract must have an ETH balance of the least `value`.
     * - the called solidity function must be `payable`.
     *
     * _Available since v3.1._
     */

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level with valude failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );

        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */

    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call filed"
            );
    }

    /**
     * @dev same as  {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delgater call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successfull, and  revert it wasn't either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                // The easiest way to bubble the revert is using memory via assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
