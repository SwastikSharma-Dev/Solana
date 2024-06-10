// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
This Project: 
1. Get fund from users.
2. Withdraw funds.
3. Set a minimum funding value in USD.
*/

// Need to use InjectedProvider - METAMASK not RemixVM

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// Above is an import of an INTERFACE
contract FundMe
{
    uint public minUSD = 5e18;
    address[] public funders;
    mapping(address funder =>uint amountFunded) public valueSent;

    function fund() public payable
    {
      //  require(msg.value >= 1e18, "You need to send more than 1 ETH, which you haven't."); // 1e18 Wei = 1*10**18 Wei = 1000000000000000000 Wei = 1ETH
      require(getConversionRates(msg.value)>=minUSD, " You didn't sent enough ETH. ");
      funders.push(msg.sender);
      valueSent[msg.sender]=msg.value+valueSent[msg.sender]; //Earlier funded data need to be added as well
    }

    // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306

    function getPrice() public view returns(uint256)
    {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price*1e10);
    }

    function getConversionRates(uint256 ethAmount) public view returns(uint256)
    {
        // To find out value of 1 ETH
        /* SOLIDITY MATHS
        Say 1ETH=2000$
        Initially, ethPrice=2000_000000000000000000 ( _ just for clarification of digits)
                   ethAmount=4_000000000000000000 (say)
                   ethAmountinUSD=8000_000000000000000000000000000000000000
                   so we need to divide by 1e18 to get the value
        */
        uint256 ethPrice=getPrice();
        uint256 ethAmountinUSD=(ethPrice*ethAmount)/1e18;
        return ethAmountinUSD;
    }

    function getVersion() public view returns (uint256)
    {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}