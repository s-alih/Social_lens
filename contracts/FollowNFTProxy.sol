// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {ILensHub} from "./ILensHub.sol";

import {Proxy} from "./Proxy.sol";
import {Address} from "./address.sol";


contract followNFTProxy is Proxy{
    using Address for address;
    address immutable HUB;

    constructor(bytes memory data){
        HUB = msg.sender;
        ILensHub(msg.sender).getFollowNFTImp().functionDelegatecall(data);
    }


    function _implementation() internal view override returns (address){
        return ILensHub(HUB).getFollowNFTImpl()
    }
}