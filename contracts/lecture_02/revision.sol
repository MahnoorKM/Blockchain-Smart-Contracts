// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MyContract {
    // receive is a built in function
    receive() external payable {// it means this contract can receive eithers
    }

    address payable owner = payable (msg.sender); // the contract deployer's address is saved here in "owner"
    uint public contractBalance = address(this).balance; // at this stage contract balance is zero

    function sendEther() public payable {
        require(msg.value >=1 ether, "Not enough money");
        contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance); // address(this).balance means current account balance, the contract which we are currently working in
    }

}