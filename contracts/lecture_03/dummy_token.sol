// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

contract dummyToken {

    mapping (address => uint) public balanceOf;
    uint public totalSupply;
    uint public mintCap = 1000;
    address owner = msg.sender;

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

     function mint(address to, uint amount) public {
        require(msg.sender == owner, "Only the owner is allowed to mint");
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Cannot mint zero or less than zero");
        require(amount <= mintCap, "Mint limit exceeded");
        balanceOf[msg.sender] += amount;  // Add newly minted tokens to recipient's balance
        totalSupply += amount;    // Increase total supply
    }

}

