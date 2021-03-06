// SPDX-License-Identifier: UNLICENSED
// Just a fancy comment.  It's called a "SPDX license identifier", feel free to Google what it is :).

// This is the version of the Solidity compiler we want our contract to use.
pragma solidity ^0.8.4;

// Some magic given to us by Hardhat to do some console logs in our contract. 
// It's actually challenging to debug smart contracts but this is one of the goodies Hardhat gives us to make life easier.
import "hardhat/console.sol";

contract WavePortal {
    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    constructor() payable  {
        console.log("Yo yo, I am a contract and I am smart just like Mecs");

        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;

    }

    // totalWaves variable that automatically is initialized to 0. 
    // But, this variable is special because it's called a "state variable" and it's cool because it's stored permanently in contract storage.
    uint256 totalWaves;
    address[] wallets;

    /*
     * A little magic, Google what events are in Solidity!
     */
    event NewWave(address indexed from, uint256 timestamp, string message);

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Wave[] waves;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;


    function wave(string memory _message) public {

         /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;


        
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }


    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
    
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function viewAddresses() public view returns (uint256) {
        console.log("Addresses who waved at us:");
        uint256 i = 0;

        for(i ; i < wallets.length; ++i) {
            console.log("%s ", wallets[i]);
        }     

        return wallets.length;
    }

}
