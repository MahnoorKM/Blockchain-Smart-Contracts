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
        mapping (address => uint256) public stakeTime;

        StakeToken public token;

         constructor (address _token){
            token = StakeToken(_token);
        }

        function stake(uint256 _amount) public {
            require (_amount > 0, "Must be greater than 0");
            stakedAmount[msg.sender] += _amount;
            token.transfer(address(this),_amount);
            stakeTime[msg.sender] = block.timestamp;
        }

        // function unStake (uint _amount) public {
        //     stakedAmount[msg.sender] -= _amount;
        //     uint reward = stakeTime[msg.sender];
        //     token.transferFrom(address(this), msg.sender, _amount);
        // }

        function withdraw() public {
            require(block.timestamp >= (stakeTime[msg.sender]) + 1 days, "Time Constraints");
            uint256 _amount = stakedAmount[msg.sender];
            require(_amount > 0, "Not staked");

            uint256 claimTime = block.timestamp - stakeTime[msg.sender];
            claimTime = claimTime / 1 days;
            uint256 reward = ((_amount * claimTime) / 100) + _amount;
         
            stakedAmount[msg.sender] -= _amount + reward;

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
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



    // contract staking2 { //classwork
    //     mapping (address => uint256) public stakedAmount;

    //     StakeToken public token;
    //     constructor (address _token){
    //         token = StakeToken(_token);
    //     }

    //     function stake (uint amount) public {
    //         stakedAmount[msg.sender] += amount;
    //         token.transfer(address(this), amount);
    //     }

    //     function unStake (uint amount) public {
    //         stakedAmount[msg.sender] += amount;
    //         token.transferFrom(address(this), msg.sender, amount);
    //     }
    // }








// first response for timelock
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TimeLock {
    address public owner;
    IERC20 public token;
    uint256 public unlockTime;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed recipient, uint256 amount);

    constructor(address _token, uint256 _unlockTime) {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        owner = msg.sender;
        token = IERC20(_token);
        unlockTime = _unlockTime;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        emit Deposited(msg.sender, amount);
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= unlockTime, "Tokens are locked");

        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");

        require(token.transfer(owner, balance), "Withdrawal failed");

        emit Withdrawn(owner, balance);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getTimeLeft() external view returns (uint256) {
        return block.timestamp >= unlockTime ? 0 : unlockTime - block.timestamp;
    }
}

   // second response timelock
   // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenTimelock {
    IERC20 public immutable token;
    address public immutable owner;
    uint256 public unlockTime;
    uint256 public lockedAmount;

    event TokensLocked(address indexed sender, uint256 amount, uint256 unlockTime);
    event TokensWithdrawn(address indexed owner, uint256 amount);

    constructor(address _token, uint256 _unlockTime) {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        
        token = IERC20(_token);
        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    function lockTokens(uint256 _amount) external {
        require(msg.sender == owner, "Only owner can lock tokens");
        require(_amount > 0, "Amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        lockedAmount += _amount;
        emit TokensLocked(msg.sender, _amount, unlockTime);
    }

    function withdrawTokens() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= unlockTime, "Tokens are still locked");
        require(lockedAmount > 0, "No tokens to withdraw");

        uint256 amount = lockedAmount;
        lockedAmount = 0;
        require(token.transfer(owner, amount), "Token transfer failed");

        emit TokensWithdrawn(owner, amount);
    }

    function getTimeLeft() external view returns (uint256) {
        return block.timestamp >= unlockTime ? 0 : unlockTime - block.timestamp;
    }
}
