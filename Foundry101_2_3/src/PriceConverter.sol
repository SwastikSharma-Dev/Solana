// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library priceConverter
{
    // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306

    function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256)
    {
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price*1e10);
    }

    function getConversionRates(uint256 ethAmount, AggregatorV3Interface s_priceFeed) internal view returns(uint256)
    {
        // To find out value of 1 ETH
        /* SOLIDITY MATHS
        Say 1ETH=2000$
        Initially, ethPrice=2000_000000000000000000 ( _ just for clarification of digits)
                   ethAmount=4_000000000000000000 (say)
                   ethAmountinUSD=8000_000000000000000000000000000000000000
                   so we need to divide by 1e18 to get the value
        */
        uint256 ethPrice=getPrice(s_priceFeed);
        uint256 ethAmountinUSD=(ethPrice*ethAmount)/1e18;
        return ethAmountinUSD;
    }

    function getVersion() internal view returns (uint256)
    {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}