// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract specialFunctions
{
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              /          \
            yes           no
            /              \
    receive() exists?    fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */
    uint256 public test;
    receive() external payable
    {
        test = 5;
    }
    fallback() external payable 
    {
        test = 10;
    }
}