// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";


interface IERC20 {
    function transferFrom(address from, address to, uint amount) external returns (bool);
    function transfer(address to, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
    function approve(address ThirdParty) external returns(bool);
}

contract Staking is ReentrancyGuard{
    IERC20 public stakingToken;

    address public owner;
    uint public rewardRate = 1;
    bool public contractPaused;

    constructor(address _stakingToken){
        owner = msg.sender;
        //takes the ERC20 token address as input when the contract is deployed.
        stakingToken =IERC20(_stakingToken);
    }

    // MAPPINGS
    mapping (address => uint) public stakeBalance;
    mapping (address => uint) public  stakeStartTime;
    mapping (address => uint) public rewardBalance;

    // MODIFIERS
    modifier  onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier whenNotPaused(){
        require(!contractPaused,"contract paused");
        _;
    }

    // FUNCTIONS

    // VIEW FUNCTIONS
    function balance(address user) public view returns (uint) {
        return stakeBalance[user];
    }

    // Stake Functions
    function stake(uint _amount)external whenNotPaused nonReentrant{
        require(_amount >0,"enter a value");

        if(stakeBalance[msg.sender] > 0){
            UpdateRewards(msg.sender);
        }

        bool success = stakingToken.transferFrom(msg.sender, address(this), _amount);
        require(success,"Transfer failed");
        stakeBalance[msg.sender] += _amount;

        stakeStartTime[msg.sender] = block.timestamp;
    }

    function unstake(uint _amount) external whenNotPaused nonReentrant{
        require(stakeBalance[msg.sender] > 0,"No stakes");
        require(_amount >0, "Enter  value");

        stakeBalance[msg.sender] -= _amount;
        bool success = stakingToken.transfer(msg.sender, _amount);
        require(success, "Transfer failed");
    }



    // REWARD FUNCTOINS 
    function UpdateRewards(address user) internal {
        uint stakedtime =block.timestamp -stakeStartTime[user];
    
        uint newRewards = stakeBalance[user] * stakedtime * rewardRate;
        rewardBalance[user] += newRewards;

        stakeStartTime[user] = block.timestamp;
    }

    function claimReward() external whenNotPaused nonReentrant{
        UpdateRewards(msg.sender);// reqards are up to date

        uint rewards = rewardBalance[msg.sender];
        require(rewards > 0,"No rewards to clain");

        rewardBalance[msg.sender] =0;
        bool success = stakingToken.transfer(msg.sender, rewards);
        require(success,"transfer failed");
    }

    // OWNER Functoins
    function emergencyWithdraw()external onlyOwner{
        uint contractBlanace = stakingToken.balanceOf(address(this));

        bool success = stakingToken.transfer(owner,contractBlanace);
        require(success,"failed");
    }

     function setRate(uint _newRate)external onlyOwner{
        require(_newRate > 0 && _newRate < 5,"Too high or low");
        rewardRate = _newRate;

    }

    function PausedContract()external onlyOwner{
        contractPaused = true;
    }

    function ResumeContract()external onlyOwner{
        contractPaused =false;
    }
}