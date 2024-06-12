// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
This Project: 
1. Get fund from users.
2. Withdraw funds.
3. Set a minimum funding value in USD.
*/

// Need to use InjectedProvider - METAMASK not RemixVM
// Above is an import of an INTERFACE

import {priceConverter} from "./PriceConverter.sol";

contract FundMe
{
  using priceConverter for uint256;
    uint public minUSD = 5e18;
    address[] public funders;
    mapping(address funder =>uint amountFunded) public valueSent;

    function fund() public payable
    {
      //  require(msg.value >= 1e18, "You need to send more than 1 ETH, which you haven't."); // 1e18 Wei = 1*10**18 Wei = 1000000000000000000 Wei = 1ETH
      require(msg.value.getConversionRates()>=minUSD, " You didn't sent enough ETH. ");
      funders.push(msg.sender);
      valueSent[msg.sender]=msg.value+valueSent[msg.sender]; //Earlier funded data need to be added as well
    }
}