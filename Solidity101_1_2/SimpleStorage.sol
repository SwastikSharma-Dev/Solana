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

    function retrieve() public view virtual returns(uint256)
    {
        return favoriteNumber; 
    }

    function jaadu() public pure returns(uint256)
    {
        return 7;
    }

    struct Person
    {
        string name;
        uint favNo;
        bool isMale;
    }

    Person public Ajay = Person("Ajay", 21, true);
    Person public Vijay = Person({name: "Vijay", favNo: 7, isMale: true});
    Person public Aarti = Person("Pooja", 11, false);

    Person[] public Friends;
    function addPerson(string memory _name, uint256 _numb, bool _male) public
    {
        // Friends.push(Person(_name,_numb,_male));
        // OR
        Person memory newPerson = Person(_name, _numb, _male);
        Friends.push(newPerson);
        // -------------------------------------
        Friends.push(Ajay);
        Friends.push(Vijay);
        Friends.push(Aarti);
    }

    mapping (string=>uint256) public NameToNumber;
    function GiveNameToNumber(string memory _name, uint256 _number) public
    {
        NameToNumber[_name]=_number;
    }
    
}