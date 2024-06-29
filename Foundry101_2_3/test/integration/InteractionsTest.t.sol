// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {console, Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Fund_FundMe, Withdraw_FundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test
{
    FundMe fundMeInstance;
    address USER = makeAddr('user');
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external 
    {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMeInstance = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public
    {
        Fund_FundMe fund_FundMe = new Fund_FundMe();
        fund_FundMe.fund_FundMe(address(fundMeInstance));
        Withdraw_FundMe withdraw_FundMe = new Withdraw_FundMe();
        withdraw_FundMe.withdraw_FundMe(address(fundMeInstance));

        assert(address(fundMeInstance).balance == 0);
    }

}