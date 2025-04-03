// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(address recipient) ERC20("MyToken", "MTK") {
        _mint(recipient, 100000 * 10 ** decimals());
    }
}

contract TimeLock {

    address public owner;
    uint256 public unlockTime;
    uint256 lockedAmount;
    MyToken public token;

    event Deposit (address sender, uint256 amount);
    event Withdraw (address recipient, uint256 amount);
    event TokensLocked(address indexed sender, uint256 amount, uint256 unlockTime);
        // mapping (address => uint256) public stakeTime;


    constructor (address _token, uint256 _unlockTime) {
        require (_unlockTime > block.timestamp, "Unlock time must be later");
        owner = msg.sender;
        token = MyToken(_token);
        unlockTime = _unlockTime;
    }
    

    function lockTokens(uint256 _amount) external {
        require(msg.sender == owner, "Only owner can lock tokens");
        require(_amount > 0, "Amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");
        lockedAmount += _amount;
        emit TokensLocked(msg.sender, _amount, unlockTime);
    }

     function withdraw() public {
            require(block.timestamp >= (unlockTime[msg.sender]) + 1 days, "Time Constraints");
            uint256 _amount = stakedAmount[msg.sender];
            require(_amount > 0, "Not staked");

            uint256 claimTime = block.timestamp - stakeTime[msg.sender];
            claimTime = claimTime / 1 days;
            uint256 reward = ((_amount * claimTime) / 100) + _amount;
         
            stakedAmount[msg.sender] -= _amount + reward;

            token.transfer(address(this), _amount + reward);
        }
    }
}








