// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract DynamicArray {
    uint256[] internal values;

    constructor() {
        values = [1, 2, 34, 56, 785];
    }

    //we set an inline assembly to write to the dynamic array called values

    function readArr(uint256 index) public view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := values.slot
        }

        // bytes32 location = keccak256(abi.encode(slot)); computes the starting
        //  location of the array elements in storage. This is because
        //  dynamic array elements are stored sequentially starting from this hash.

        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))
        }
    }

    function addArr(uint256 data) public {
        uint256 slot1;
        //we set an inline assembly to write to the dynamic array called values
        assembly {
            slot1 := values.slot //gets the storage slot where the values array is stored
        }
        //get the current length of the array
        uint256 len;

        assembly {
            len := sload(slot1) //reads the current length of the array from storage.
        }
        //calculate the storage location of the new element
        bytes32 loc = keccak256(abi.encode(slot1)); //computes the starting location of the array elements in storage.

        //write the new element to the storage
        assembly {
            sstore(add(loc, len), data) //writes the data to the calculated storage location (loc + len).
        }
        //update the array length
        assembly {
            sstore(slot1, add(len, 1)) // increments the array length by 1 and updates it in storage.
        }
    }

    // Reads all elements of the values array and returns them as a new array.

    function readAll() public view returns (uint256[] memory ret) {
        uint256 slot;
        assembly {
            slot := values.slot //Gets the storage slot where the values array is primary located 
        }

        uint256 len;
        assembly {
            len := sload(slot) //It will read the current length array from the storage
        }
        //Initialize the returning point of the array

        ret = new uint256[](len); //creates anew temporary in memory array of size len

        //Calculate the starting point location of the array elements

        bytes32 location = keccak256(abi.encode(slot));
        assembly {
            for {
                let i := 0
            } lt(i, len) {
                i := add(i, 1)
            } {
                let data := sload(add(location, i)) //reads the element at index i
                mstore(add(ret, add(32, mul(i, 32))), data) //stores the element in the return array at the correct memory location
            }
        }
    }
}
