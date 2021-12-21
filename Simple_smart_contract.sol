pragma solidity ^0.8.0;

contract Simple {

    string myString = "My default String";

    function setString(string memory newString) external {
        myString = newString;
    }

    function getString () external view returns (string memory){
        return myString;

     }


}
