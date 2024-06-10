// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage // is statement help[s us to inherit all the functionalities(fn) and varibales of the parent contract
{
    function sayHello() pure public returns (string memory)
    {
        return "Hello";
    }

    function retrieve() override public view returns (uint)
    {
        return favoriteNumber+5;
    }
}