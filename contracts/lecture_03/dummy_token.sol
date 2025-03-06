// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

contract dummyToken {

    mapping (address => uint) public balanceOf;

    function deposit(uint amount) public {
        balanceOf[msg.sender] = amount;
    }

    function transfer (address sender, address recipient, uint amount) public returns (bool) {
        require(balanceOf[sender] >= amount, "Not enough balance");
        require(recipient != address(0), "Zero address detected");
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        return true;
    }

}