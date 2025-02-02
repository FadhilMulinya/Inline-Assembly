// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/*
============================================================
                      CONTRACT: Mapppings
============================================================
This contract demonstrates how to use mappings in Solidity.
Mappings are like magical dictionaries that store key-value pairs.
Here, we have two types of mappings:
1. A simple mapping: `myMapping`
2. A mapping of addresses to lists: `addToList`
*/

contract Mapppings {
    /*
    ============================================================
                        MAPPING 1: myMapping
    ============================================================
    - This is a simple mapping where:
      - Key: A number (uint256)
      - Value: Another number (uint256)
    - Think of it like a phone book:
      - You look up a name (key) and get a phone number (value).
    */
    mapping(uint256 => uint256) private myMapping;

    /*
    ============================================================
                        MAPPING 2: addToList
    ============================================================
    - This is a more complex mapping where:
      - Key: An Ethereum address (address)
      - Value: A list of numbers (uint256[])
    - Think of it like a school register:
      - Each student (address) has a list of grades (numbers).
    */
    mapping(address => uint256[]) private addToList;

    /*
    ============================================================
                        CONSTRUCTOR
    ============================================================
    - The constructor is like a setup function that runs once
      when the contract is deployed.
    - Here, we initialize some values in the mappings.
    */
    constructor() {
        // Initialize myMapping with some values
        myMapping[0] = 230;   // Key: 0, Value: 230
        myMapping[1] = 1000;  // Key: 1, Value: 1000
        myMapping[2] = 800;   // Key: 2, Value: 800

        // Initialize addToList with a list of numbers for a specific address
        addToList[0xDA0bab807633f07f013f94DD0E6A4F96F8742B53] = [98, 40, 100];
    }

    /*
    ============================================================
                        FUNCTION: getMappingValue
    ============================================================
    - This function retrieves a value from `myMapping` using a key.
    - It uses inline assembly to calculate the storage location
      and load the value.
    */
    function getMappingValue(uint256 key) public view returns (uint256 ret) {
        // Variable to store the base slot of the mapping
        uint256 slot;

        // Inline Assembly Block: Get the base slot of `myMapping`
        assembly {
            slot := myMapping.slot
        }

        /*
        ============================================================
                        STORAGE SLOT CALCULATION
        ============================================================
        - Solidity uses a formula to calculate the storage location
          for mappings:
            location = keccak256(abi.encode(key, baseSlot))
        - Here:
          - `key`: The key you're looking up.
          - `baseSlot`: The base storage slot of the mapping.
        */
        bytes32 location = keccak256(abi.encode(key, uint256(slot)));

        // Inline Assembly Block: Load the value from the calculated location
        assembly {
            ret := sload(location)
        }
    }

    /*
    ============================================================
                        FUNCTION: getAddressToList
    ============================================================
    - This function retrieves the first value from the list
      stored in `addToList` for a specific address.
    - It uses inline assembly to calculate the storage location
      and load the value.
    */
    function getAddressToList() external view returns (uint256 ret) {
        // Variable to store the base slot of the mapping
        uint256 slotList;

        // Inline Assembly Block: Get the base slot of `addToList`
        assembly {
            slotList := addToList.slot
        }

        /*
        ============================================================
                        STORAGE SLOT CALCULATION
        ============================================================
        - For mappings with complex keys (like addresses), the formula
          is similar:
            location = keccak256(abi.encode(key, baseSlot))
        - Here:
          - `key`: The address you're looking up.
          - `baseSlot`: The base storage slot of the mapping.
        */
        bytes32 location = keccak256(
            abi.encode(
                address(0xDA0bab807633f07f013f94DD0E6A4F96F8742B53),
                uint256(slotList)
            )
        );

        // Inline Assembly Block: Load the value from the calculated location
        assembly {
            ret := sload(location)
        }
    }
}

// addToList:
//     Address: 0xDA0bab807633f07f013f94DD0E6A4F96F8742B53 → List: [98, 40, 100]















