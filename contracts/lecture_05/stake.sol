// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
// 20 marh 2025
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeToken is ERC20 {
    constructor(address recipient) ERC20("StakeToken", "MTK") {
        _mint(recipient, 1000000 * 10 ** decimals());
    }
}

    contract staking {
        mapping (address => uint) public stakedAmount;

        StakeToken public token;

        function stake(uint256 _amount) public {
            stakedAmount[msg.sender] += _amount;
            token.transfer(address(this),_amount);
        }
    }
