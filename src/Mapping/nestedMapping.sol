// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/*
============================================================
                      CONTRACT: nestedMappings
============================================================
This contract demonstrates how to work with **nested mappings** in Solidity
and how to access nested mapping values using **inline assembly**.
Nested mappings are like **folders inside folders**, where you need two keys
to find a specific file. Inline assembly is like **peeking under the hood**
of Solidity to directly interact with the Ethereum Virtual Machine (EVM).
*/

contract nestedMappings {
    /*
    ============================================================
                        NESTED MAPPING: nestMaps
    ============================================================
    - This is a **nested mapping** where:
      - The **first key** (uint256) points to another mapping.
      - The **second key** (uint256) points to a value (uint256).
    - Think of it like a **filing cabinet**:
      - The first key opens a drawer.
      - The second key opens a folder inside the drawer to find a file.
    */
    mapping(uint256 => mapping(uint256 => uint256)) nestMaps;

    /*
    ============================================================
                        CONSTRUCTOR
    ============================================================
    - The constructor is like a **setup function** that runs once
      when the contract is deployed.
    - Here, we initialize the nested mapping with a sample value.
    */
    constructor() {
        // Set nestMaps[1][2] = 800
        nestMaps[1][2] = 800;
    }

    /*
    ============================================================
                        FUNCTION: getNest
    ============================================================
    - This function retrieves the value stored in `nestMaps[1][2]`.
    - It uses **inline assembly** to calculate the storage location
      and load the value.
    */
    function getNest() public view returns (uint256 ret) {
        // Variable to store the base slot of the nested mapping.
        uint256 slot;

        /*
        ============================================================
                        INLINE ASSEMBLY: Get Base Slot
        ============================================================
        - In Solidity, mappings don’t store data directly. Instead,
          they use a **hashing formula** to calculate storage locations.
        - The `nestMaps.slot` gives the **base storage slot** of the mapping.
        - Inline assembly is used here to directly access the EVM.
        */
        assembly {
            slot := nestMaps.slot
        }

        /*
        ============================================================
                        STORAGE SLOT CALCULATION
        ============================================================
        - Solidity uses the following formula to compute the storage slot
          for nested mappings:
            location = keccak256(abi.encode(key2, keccak256(abi.encode(key1, baseSlot))))
        - Here:
          - `key1 = 1` (first key)
          - `key2 = 2` (second key)
          - `baseSlot = nestMaps.slot` (base storage slot of the mapping)
        */
        bytes32 location = keccak256(
            abi.encode(
                uint256(2), // Second key (key2)
                keccak256(abi.encode(uint256(1), uint256(slot))) // First key (key1) and base slot
            )
        );

        /*
        ============================================================
                        INLINE ASSEMBLY: Load Value
        ============================================================
        - The `sload` opcode is used to load the value from the calculated
          storage location.
        - The value stored at `nestMaps[1][2]` is returned as `ret`.
        - Inline assembly is used here to directly interact with the EVM.
        */
        assembly {
            ret := sload(location)
        }
    }
}