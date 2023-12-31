// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FixedStaking is ERC20 {
    mapping(address => uint256) public staked;
    mapping(address => uint256) private stakedfromTS;
    constructor() ERC20("Fixed Staking", "FIX") {
        _mint(msg.sender, 10000000000);
    }
    function stake(uint256 amount) external {
        require(amount > 0, "amount is <= 0");
        require(balanceOf(msg.sender) >= amount, "balance is <= amount");
        _transfer(msg.sender, address(this), amount);
        if (staked[msg.sender] > 0){
            claim();
        }
        stakedfromTS[msg.sender] = block.timestamp;
        staked[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "amount is <= 0");
        require(staked[msg.sender] >= amount, "amount is > staked");
        claim();
        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    function claim() public {
        require(staked[msg.sender] > 0, "staked is <= 0");
        uint256 secondsStaked = block.timestamp - stakedfromTS[msg.sender];
        uint256 rewards = staked[msg.sender] * secondsStaked / 3.154e7;
        _mint(msg.sender,rewards);
        stakedfromTS[msg.sender] = block.timestamp;
    }
}