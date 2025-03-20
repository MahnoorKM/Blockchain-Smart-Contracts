// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
// staking contract
// make a smart contract where you invest tokens and get 5% interest on it when you withdraw
// no time log for now
// not my implementation

contract SimpleStaking {
    uint256 public constant INTEREST_RATE = 5; // 5% interest
    mapping(address => uint256) public stakedBalances;

    event Staked(address user, uint256 amount);
    event Withdrawn(address user, uint256 amountWithInterest);

    function stake() external payable {
        require(msg.value > 0, "Must stake some ETH");
        stakedBalances[msg.sender] += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "No staked balance to withdraw");

        uint256 interest = (stakedAmount * INTEREST_RATE) / 100;
        uint256 totalAmount = stakedAmount + interest;

        stakedBalances[msg.sender] = 0;
        payable(msg.sender).transfer(totalAmount);

        emit Withdrawn(msg.sender, totalAmount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}