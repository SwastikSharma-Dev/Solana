// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {SimpleStorage} from "./SimpleStorage.sol";
// ----------------------------OR------------------------------
// import "./SimpleStorage.sol";
//-----------------------------OR------------------------------
// contract SimpleStorage
// {
//     uint256 public favoriteNumber;
//     function store(uint256 _favoriteNumber) public
//     {
//         favoriteNumber=_favoriteNumber;
//         jaadu();
//     }

//     function retrieve() public view returns(uint256)
//     {
//         return favoriteNumber; 
//     }

//     function jaadu() public pure returns(uint256)
//     {
//         return 7;
//     }

//     struct Person
//     {
//         string name;
//         uint favNo;
//         bool isMale;
//     }

//     Person public Ajay = Person("Ajay", 21, true);
//     Person public Vijay = Person({name: "Vijay", favNo: 7, isMale: true});
//     Person public Aarti = Person("Pooja", 11, false);

//     Person[] public Friends;
//     function addPerson(string memory _name, uint256 _numb, bool _male) public
//     {
//         // Friends.push(Person(_name,_numb,_male));
//         // OR
//         Person memory newPerson = Person(_name, _numb, _male);
//         Friends.push(newPerson);
//         // -------------------------------------
//         Friends.push(Ajay);
//         Friends.push(Vijay);
//         Friends.push(Aarti);
//     }

//     mapping (string=>uint256) public NameToNumber;
//     function GiveNameToNumber(string memory _name, uint256 _number) public
//     {
//         NameToNumber[_name]=_number;
//     } 
// }
//-------------------------------------------------------------------------------

contract StorageFactory
{
    // SimpleStorage public simpleStorage;
    // function createSimpleStorageContract() public
    // {
    //     simpleStorage = new SimpleStorage();
    // }
    //-------------------------------------------------
    SimpleStorage[] public ListOfSimpleStorageContracts;

    function createListofSimpleStorageContracts() public
    {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        ListOfSimpleStorageContracts.push(newSimpleStorage);
    }


    function sfStore(uint _simpleStorageIndex, uint _simpleStorageNumber) public
    {
        SimpleStorage mySimpleStorage = ListOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint _index) view public returns(uint)
    {
        SimpleStorage temp = ListOfSimpleStorageContracts[_index];
        return temp.retrieve();
    }
    // In this portion of code. createListofSimpleStorageContracts() creates an arbitrary Simple Storage Contract and pushes into the ListOfSimpleStorageContract[]
    // sfStore() saves a number i.e. favourite number into that saved contact by passing number and index of smart contarct as parameter.
    // sfGet() retrive the favoutite number of the SimpleStorage Contract by passing its index as parameter.
    // .retrieve() and .store() functions are created in SimpleStorage.sol itself. Just imported here.
    //--------------------------------------------------
    //address[] public ListOfSimpleStorageAddresses;
    // we can create an array of type address and then can explicitly convert the SimpleStorage type contract adrress received via new SimpleStorage();
}