// SPDX-License-Identifier: UNLICENSED
// Just a fancy comment.  It's called a "SPDX license identifier", feel free to Google what it is :).

// This is the version of the Solidity compiler we want our contract to use.
pragma solidity ^0.8.4;

// Some magic given to us by Hardhat to do some console logs in our contract. 
// It's actually challenging to debug smart contracts but this is one of the goodies Hardhat gives us to make life easier.
import "hardhat/console.sol";

contract WavePortal {
    constructor() {
        console.log("Yo yo, I am a contract and I am smart just like Mecs");
    }

    // totalWaves variable that automatically is initialized to 0. 
    // But, this variable is special because it's called a "state variable" and it's cool because it's stored permanently in contract storage.
    uint256 totalWaves;
    address[] wallets;

    function wave() public {
        totalWaves += 1;
        // We also use some magic here with msg.sender. This is the wallet address of the person who called the function. This is awesome! It's like built-in authentication. 
        // We know exactly who called the function because in order to even call a smart contract function, you need to be connected with a valid wallet!
        console.log("%s has waved!", msg.sender);
        wallets.push(msg.sender);
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
