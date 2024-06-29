# sudo apt install make   ---   if 'make' is not installed
# this file helps to compile and do other stuffs we do on Terminal directly and easily
-include .env # include the .env file

build:; forge build # :; when writing code in same line
deploy-sepolia:
	forge script script/DeployFundMe.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
