// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {Errors} from "./Errors.sol";

/**
 * @title VersionInitializable
 *
 * @dev Helper contract to implement initializer function. To use it, replace the
 * constructor with function that has `intitializer` modifier.
 * WARNING: Unlike constructors. initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract. as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be take to not invoke
 * a parent initializer twice. or ensure that all initializers are idempotent.
 * because this hot dealt with automatically as with constructors.
 *
 * This is slightly modified form [Aave's version](https://github.com/aave/protocol-v2/blob/6a503eb0a897124d8b9d126c915ffdf3e88343a9/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol)
 *
 * @author Lens Protocol, inspired by Aave's implementaion, which in turn inspired by OpenZeppelin's
 * Initializable contract
 */

abstract contract VersionInitializable {
    address private immutable originalImpl;

    /**
     * @dev Indicate that the contract has been initilized
     */
    uint256 private lastInitiliazedRevision = 0;

    /**
     * @dev Modifier to use in the initializer function of a contract,
     */

    modifier initializer() {
        uint256 revision = getRevision();
        if (address(this) == originalImpl)
            revert Errors.CannotInitImplementation();
        if (revision <= lastInitiliazedRevision) revert Errors.initilized()
        lastInitilizedRevision = revision;
        _;
    }

    constructor(){
        originalImpl = address(this);
    }

    /**
     * @dev returns the revision number of the contract
     * Needs to be defined in the inherited class as a contant.
     */

    function getRevision() internal pure virtual returns(uint256);
}
