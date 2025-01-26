// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract yulArrays {

    /**declaring a fixed-size aray in storage of uint256 bytes
    *Varible is stoted in contracts storage which is expensve to access but persistent
    ***/

    uint256[4] data = [300,500,800,200];

   /**Takes an index as input and returns the value at that index in the data array
   *
   **/
    function readData(uint256 index) public view returns(uint256 res){
        assembly {
            let step := data.slot //.slot returns the storage slot where the data array of index n is stored value 0 is assigned here btw
            res := sload(add(step,index))
            //add built in function to add two numbers 
            //step the base storage of slot data which is 0
            //index input parameter passed
            //result of add(a,b) is storage slot for the elements at given index in the data array
            //ie if index == 0 , slot equals 0+0 ; index == 1, slot equals 0+1 , etc
            //sload opcode that reads 256-bit value from the specified  storage slot
            //so after adding the index and the slot it will load the result
        }
    }

        function writeData(uint256 index, uint256 _data)public {
            assembly {
                let step := data.slot
                sstore(add(index,step), _data)
            }

            //store will store the data parsed to the storage slot

        }

        function readAllData() public view returns(uint256[] memory){
            //This allocates memory for a dynamic array of length 4. 
            //The array is stored in memory, and result points to its starting location.
            uint256[] memory result = new uint256[](4);
            assembly {

                //data.slot returns the base storage slot of the data array (which is 0 in this case).
                let step :=  data.slot

                //Loop through this array 

                for{ let i := 0} lt(i,4) {i := add(i,1) } {

                    //read each element from the storage correspondinf to the ith element of data array

                    let value := sload(add(step, i))

                    //store the elements in an memory

                    mstore(add(add(result, 0x20), mul(i, 0x20)), value)

                }
            }
            return result;

            //First 32 bytes: stores Length of the array.

            //Subsequent 32-byte chunks: Elements of the array.
        }
    
}
     // Example: Memory Layout of a Dynamic Array
     //so lets say you have a dynamic array of :
          //uint256[] memory arr = new uint256[](3) of values [100,200,300]
          //The memory layout looks like this
    //        Memory Offset   (Hex)	     Memory Offset (Decimal)	Data Stored
    //        arr (start)	    0	         Length of array (3)
    //        arr + 0x20	    32	         First element (100)
    //        arr + 0x40	    64	         Second element (200)
    //        arr + 0x60	    96	         Third element (300)
