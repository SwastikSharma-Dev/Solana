// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;
// Work
// 1. Deploy mocks when we are on Local Anvil Chain
// 2. Keep track of Adresses across Different Chains

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script
{
    // If we are on Anvil, we deploy mocks
    //Otherwise, grab the existing addresses from live network

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig
    {
        address priceFeed; //ETH/USD Price Feed Address
        // More if we want to.
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory)
    {
        NetworkConfig memory SepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return SepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory)
    {
        return NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory)
    {
        // Can't be pure because using vm. And to use vm it must inherit Script
        // For ANVIL,
        // 1. Deploy mocks --> MOCKS: A contract we can manage. Kinda dummy-- or --a real one under our control
        // 2. Return mock address

        // if(activeNetworkConfig.priceFeed != address(0)) return activeNetworkConfig;
        // The above is when there is already an activeNetworkConfig, we must not create a new one and waste time/computation/gas.
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }

    constructor()
    {
        if(block.chainid == 11155111)
        {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 1)
        {
            activeNetworkConfig = getMainnetEthConfig();
        }
        else
        {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
}
