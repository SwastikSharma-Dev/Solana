// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test
{
    // For every Test, SetUp() euns first and then test and after completion everything resets and for next test same process initializes.

    FundMe fundMeInstance;
    address USER = makeAddr('user'); // Can't make it constant beacuse it is a compile time constant
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external 
    {
        //fundMeInstance = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMeInstance = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }
    function testIsOwner() public view
    {
        console.log("i_owner = ",fundMeInstance.getOwner()); //0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        console.log("msg.sender = ",msg.sender); //0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        console.log("address.this = ",address(this)); //0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        /*Since we are deploying FundMeTest we are its owner but the instance of FundMe i.e. fundMeInstance
        is created by this FundMeTest Contract so it is the instance's owner. And as we are sender in msg.sender,
        the assert equation will not be true so we need to change msg.sender to address(this) for testing case.
        Ownership:  US(WE)->FundMeTest->fundMeInstance*/
        assertEq(fundMeInstance.getOwner(), msg.sender); // FOR REST
        //assertEq(fundMeInstance.i_owner(), address(this)); //FOR ANVIL
    }
    function testCheckMINUSD() public view
    {
        assertEq(fundMeInstance.MIN_USD(),5e18);
        //assertEq(fundMeInstance.MIN_USD(),6e18);
    }
    function testPriceFeedVersion() public view
    {
        uint256 version = fundMeInstance.getVersion();
        assertEq(version,4);
    }

    function testFundFailsWithoutEnoughETH() public
    {
        vm.expectRevert(); // A CheatCode which Expect Next Line to Fail. If next Line Fails it Passes and vice-versa.
        // uint256 abcd = 1; // This won't fail and thus our Test Fails
        fundMeInstance.fund(); // We sent 0 as Value, so it will Fail and the Test will Pass.
    }

    function testFundUpdatesFundedDataStructure() public 
    {
        // We can create a fake User for sending transactions using chaetcode: PRANK
        vm.prank(USER); // The next Transaction will be sent by the "USER"
        // BUT*** Since newly created prank "USER" don't have Money, it can't send Transactions. We need to use another Cheat Code.
        fundMeInstance.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMeInstance.getAddressToAmountFunded(USER); // Using Prank Function
        //uint256 amountFunded = fundMeInstance.getAddressToAmountFunded(address(this));
        // assertEq(amountFunded, 11e18); // Fails
        assertEq(amountFunded, SEND_VALUE); // Passes
    }

    function testAddsFundertoArrayofFunders() public funded
    {
        // vm.prank(USER);
        // fundMeInstance.fund{value: SEND_VALUE}();


        address funder = fundMeInstance.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded
    {

        vm.expectRevert(); // Check for Next Line to Fail but SKIPS CheatCodes

        vm.prank(USER);
        fundMeInstance.withdraw();
    }

    modifier funded() 
    { // Good Practise to Save Lines of Codes
        vm.prank(USER);
        fundMeInstance.fund{value: SEND_VALUE}();
        _;
    }

    function testWithdrawWithASingleFunder() public funded
    {
        // ARRANGE
        uint256 ownerStartingBalance = fundMeInstance.getOwner().balance;
        uint256 contractStartingBalance = address(fundMeInstance).balance;

        // ACT
        // vm.txGasPrice(GAS_PRICE); // CheatCode for Gas Price for Tests
        // uint256 gasStart = gasleft(); // Inbuilt Function that gives the Gas Left in the Transaction
        vm.prank(fundMeInstance.getOwner());
        fundMeInstance.withdraw();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart-gasEnd)* tx.gasprice; // tx.gasprice is Built-In Solidity that gives Current Gas Price

        // console.log("gasUsed = ", gasUsed);

        // ASSERT
        uint256 endingOwnerBalance = fundMeInstance.getOwner().balance;
        uint256 endingContractBalance = address(fundMeInstance).balance;
        assertEq(endingOwnerBalance, ownerStartingBalance+contractStartingBalance);
        assertEq(endingContractBalance, 0);

    }
    
    // HOAX is Prank and DEAL Combined CheatCode
    // Moreover, Prank only works for next line only but startPrank() and stopPrank() are useful for multiple code lines; works for code lines enclosed between them.

    function testWithdrawFromMultipleFunders() public
    {
        // Solidty no longer convert from uint256 to address but uint160
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i=startingFunderIndex; i<numberOfFunders; i++)
        {
            hoax(address(i),SEND_VALUE);
            fundMeInstance.fund{value: SEND_VALUE}();
        }
        uint256 ownerStartingBalance = fundMeInstance.getOwner().balance;
        uint256 contractStartingBalance = address(fundMeInstance).balance;

        vm.prank(fundMeInstance.getOwner());
        fundMeInstance.withdraw();

        assert(address(fundMeInstance).balance==0);
        assert(contractStartingBalance + ownerStartingBalance == fundMeInstance.getOwner().balance);
        
    }

    function testWithdrawFromMultipleFundersCheaper() public
    {

        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i=startingFunderIndex; i<numberOfFunders; i++)
        {
            hoax(address(i),SEND_VALUE);
            fundMeInstance.fund{value: SEND_VALUE}();
        }
        uint256 ownerStartingBalance = fundMeInstance.getOwner().balance;
        uint256 contractStartingBalance = address(fundMeInstance).balance;

        vm.prank(fundMeInstance.getOwner());
        fundMeInstance.cheaperWithdraw();

        assert(address(fundMeInstance).balance==0);
        assert(contractStartingBalance + ownerStartingBalance == fundMeInstance.getOwner().balance);
        
    }

    function testWithdrawWithASingleFunderCheaper() public funded
    {

        uint256 ownerStartingBalance = fundMeInstance.getOwner().balance;
        uint256 contractStartingBalance = address(fundMeInstance).balance;

        vm.prank(fundMeInstance.getOwner());
        fundMeInstance.cheaperWithdraw();

        uint256 endingOwnerBalance = fundMeInstance.getOwner().balance;
        uint256 endingContractBalance = address(fundMeInstance).balance;
        assertEq(endingOwnerBalance, ownerStartingBalance+contractStartingBalance);
        assertEq(endingContractBalance, 0);

    }

  

}