// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
contract myStructs {

    struct Person {
        string name;
        uint256 age;
        uint256 height;
        bool legal;
    }

    mapping(uint256 => Person) private people;

    event personCreated(string name, uint256 age, uint256 height, bool legal);

    function addPerson(Person memory person) public {
        //Person memory newPerson;
        assembly {
            //load the free memory pointer
            let freeMem := mload(0x40)

            //store the person struct in memory

            mstore(freeMem, mload(add(person, 0x20))) //copy the 'name' field (name string offset)
            mstore(add(freeMem, 0x20), mload(add(person, 0x40))) //copy the 'age' field (age uint256 offset)
            mstore(add(freeMem, 0x40), mload(add(person, 0x60))) //copy the 'height' field (height uint256 offset)
            mstore(add(freeMem , 0x60), mload(add(person, 0x80))) //copy the 'legal' field (legal bool offset)

            //update the free memory pointer

            mstore(0x40, add(freeMem, 0x80)) //update the free memory pointer

        }
        emit personCreated(person.name, person.age, person.height, person.legal);
    }

    function readStruct(uint256 index) public view returns(Person memory persons){
        uint256 person ;
        assembly {
             person := people.slot
        }
        //storage slot calclation

        bytes32 location = keccak256(abi.encode(index, uint256(person)));

        assembly {
            persons := sload( location) 
        }
    }


}