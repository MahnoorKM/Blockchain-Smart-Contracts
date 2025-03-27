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

    contract staking { //implementation steps written in notepad
        mapping (address => uint256) public stakedAmount;

        StakeToken public token;

         constructor (address _token){
            token = StakeToken(_token);
        }

        function stake(uint256 _amount) public {
            require (_amount > 0, "Must be greater than 0");
            stakedAmount[msg.sender] += _amount;
            token.transfer(address(this),_amount);
        }

        function withdraw() public {
            uint256 _amount = stakedAmount[msg.sender];
            require(_amount > 0, "Not staked");
            uint256 reward = (_amount *5 ) / 100;

            token.transfer(address(this), _amount + reward);
        }
    }
/* 1. first deploy your token (and copy the address of account)
2. then copy the address of this deployed token
3. then select the staking contract and paste the address of the deployed token
4. copy the address of the staking contract and go to the token deployed section => select "transfer" function and paste the address of the staking contract and mint (click transfer)
5. now go to the staking contract and enter a value in "stake"
6. copy the address of the account from which this was deployed and paste in "stakedAmount" function
*/
// ----------------------------------------------------------------------------------------------------------
    contract staking2 { //classwork
        mapping (address => uint256) public stakedAmount;

        StakeToken public token;
        constructor (address _token){
            token = StakeToken(_token);
        }

        function stake (uint amount) public {
            stakedAmount[msg.sender] += amount;
            token.transfer(address(this), amount);
        }

        function unStake (uint amount) public {
            stakedAmount[msg.sender] += amount;
            token.transferFrom(address(this), msg.sender, amount);
        }
    }

   