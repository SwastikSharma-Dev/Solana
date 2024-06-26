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
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FundMe__notOwner();
error FundMe__lessAmount();

contract FundMe
{
  using priceConverter for uint256;
    uint public constant MIN_USD = 5e18;
    address[] public s_funders;
    mapping(address funder =>uint amountFunded) private s_valueSent;
    address private immutable i_owner; // The deploying account of the wallet
    AggregatorV3Interface private s_priceFeed;


    function fund() public payable
    {
      // require(msg.value >= 1e18, "You need to send more than 1 ETH, which you haven't."); // 1e18 Wei = 1*10**18 Wei = 1000000000000000000 Wei = 1ETH
      // require(msg.value.getConversionRates()>=MIN_USD, " You didn't sent enough ETH. ");
      if(msg.value.getConversionRates(s_priceFeed)<MIN_USD){revert FundMe__lessAmount();}
      s_funders.push(msg.sender);
      s_valueSent[msg.sender]+=msg.value; //Earlier funded data need to be added as well
    }

    /* 
       There are three diffrent ways: 1.send 2.transfer 3. call
       to send an amount from a contract to a wallet or another contract
       https://solidity-by-example.org/sending-ether/
    */

    // We do not want anyone to call withdraw function and take away all the money.
    // It need to be called by only its owner. fund() may be called by anyone; no problem
    // So we can use a fn to keep a check on it and it should be called immediately on withdraw execution. So instead, we can simply use CONSTRUCTOR
    // 'constructor' keyword is used to make a constructor. It is immediately called on contract deployment not on transaction.

    constructor(address priceFeed)
    {
      i_owner=msg.sender;
      s_priceFeed=AggregatorV3Interface(priceFeed);
    }

    function cheaperWithdraw() public onlyOwner
    {

        // It is 33x times efficient to Store or Read from Memory(MLOAD and MSTORE : 3) rather than Storage(SLOAD and SSTORE : 100)

      uint256 fundersLength=s_funders.length;

      for(uint i=0; i<fundersLength; i++)
      {
        address addOfFunders = s_funders[i];
        s_valueSent[addOfFunders]=0;
      }
      s_funders=new address[](0);

      (bool callSuccess, )=payable(msg.sender).call{value: address(this).balance}("");
      require(callSuccess, "Call Failed");
      
    }




    function withdraw() onlyOwner public
    {
      for(uint i=0; i<s_funders.length; i++)
      {
        address addOfFunders = s_funders[i];
        s_valueSent[addOfFunders]=0;
      }
      s_funders=new address[](0);
      //Resets the array funders to new address array staring from address 0

      // /* 
      // Easiest way is to use transfer.
      // We will need to type cast msg.sender which is address type to payable type
      // .transfer will get parameter of amount to be transfered which is given as the balance of this current contract by using address(this) to get address of this current contract and .balance utility to get its balance
      // */
      // payable(msg.sender).transfer(address(this).balance);
      // //--------------------------------------------------------------


      // // .send returns its success as bool
      // bool sentSuccess=payable(msg.sender).send(address(this).balance);
      // require(sentSuccess, "Sending Failed");
      // //---------------------------------------------------------------


      // .call returns two variables (bool //callSuccess,bytes //ReceivedData)
      // .call is a low level implemention and has no gas fee restriction which is 2300 is above two methods
      // bytes must be a memory varibale 
      // MOST RECOMMENDED WAY
      (bool callSuccess, )=payable(msg.sender).call{value: address(this).balance}("");
      require(callSuccess, "Call Failed");
    }



    // Modifiers are used to save time in writing same line of code and conditions in execution of different functions.
    // We just declare the condition (here Owner Condition) inside this and we now need not to write it in every function.
    // Now we just need to write Modifier name in function declaration next to its visbility.
    //Whenever that function is callled, first modifier runs and then function.

    modifier onlyOwner() //no need to declare visibility as done in functions
    {
      // //require(msg.sender==address(this), "Only owner can Withdraw");
      // require(msg.sender==i_owner, "Only owner can Withdraw");
      if(msg.sender!=i_owner)
      {
        revert FundMe__notOwner();
      }
      _; //Do whatever function wants to.
    }

    receive() external payable
    {
      fund();
    }

    fallback() external payable
    {
      fund();
    }

    /**
     * View/Pure (Getter) Functions
     */

    /**
     * @notice Gets the amount that an address has funded
     *  @param fundingAddress the address of the funder
     *  @return the amount funded
     */
    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_valueSent[fundingAddress];
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    // function getOwner() public view returns (address) {
    //     return i_owner;
    // }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

  function getOwner() external view returns (address)
  {
    return i_owner;
  }

}