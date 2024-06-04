// SPDX-License-Identifier: MIT
pragma solidity 0.8.26; //Soliidty Version we wish to use
contract SimpleStorage
{
    uint256 public favoriteNumber;
    function store(uint256 _favoriteNumber) public
    {
        favoriteNumber=_favoriteNumber;
        jaadu();
    }

    function retrieve() public view returns(uint256)
    {
        return favoriteNumber; 
    }

    function jaadu() public pure returns(uint256)
    {
        return 7;
    }
}