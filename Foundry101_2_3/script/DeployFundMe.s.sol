// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script
{
    function run() external returns (FundMe)
    {
    // Before Broadcast -> Not a Real Transaction. Do not need Gas.
    HelperConfig helperConfig = new HelperConfig(); // Will save gas if used before startBroadcast()
    address ethUsdPriceFeed  = helperConfig.activeNetworkConfig();
    vm.startBroadcast();
    // After Broadcast -> A Real Transaction. Needs Gas.
    FundMe fundMe = new FundMe(ethUsdPriceFeed);
    vm.stopBroadcast();
    return fundMe;
    }
}