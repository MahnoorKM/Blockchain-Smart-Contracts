// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Mahnoor is ERC20 {
    constructor(address recipient) ERC20("Mahnoor", "MTK") {
        _mint(recipient, 10000000000 * 10 ** decimals());
    }
}

event List (address token, uint256 totalAmount);
event Buy (address sender, uint256 totalAmount);

contract ERC20Auction {
    struct Listing {
        address seller;
        IERC20 token;
        uint pricePerToken; // ETH per token (e.g 0.01 ether)
        uint remainingAmount;
    }

    Listing[] public listings;


function ListTokens (IERC20 token, uint totalAmount, uint pricePerToken) public payable {
    require (totalAmount > 0, "Must be greater than 0");
    token.transferFrom(msg.sender, address(this), totalAmount);
}

    function BuyTokens (uint ListingID, uint TokenAmount) public payable {
        // require(block.timestamp >= (Listing[msg.sender]) + 1 days, "Time Constraints");
        require(ListingID < listings.length);
        require(listings[ListingID].remainingAmount >= TokenAmount);
        IERC20 token = listings[ListingID].token;
        uint pricePerToken = listings[ListingID].pricePerToken;
        require(msg.value >= TokenAmount * pricePerToken);
       // if amount of tokens are higher then balance it will throw an error 
         token.transferFrom(address(this), msg.sender, TokenAmount);
    }

    function getListCount() view public returns (uint) {
        return listings.length;
    }

}