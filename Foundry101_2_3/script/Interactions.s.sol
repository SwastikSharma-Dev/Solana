// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
import {console} from "forge-std/console.sol";
// Run this in Terminal for Installation of DevOps Library : "forge install Cyfrin/foundry-devops --no-commit"
// We can run Bash Scripts as well form Foundry. For that, go to foundry.toml and write "ffi=true"


contract Fund_FundMe is Script
{
    uint256 SEND_VALUE = 0.1 ether;

    function fund_FundMe(address mostRecentlyDeployed) public 
    {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external
    {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fund_FundMe(mostRecentlyDeployed);
    }
}

contract Withdraw_FundMe is Script
{
    uint256 SEND_VALUE = 0.1 ether;

    function withdraw_FundMe(address mostRecentlyDeployed) public 
    {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external
    {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdraw_FundMe(mostRecentlyDeployed);
    }
}
