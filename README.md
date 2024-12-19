# Staking-contract

Overview
The Staking Contract allows users to stake their ERC-20 tokens, earn rewards, and withdraw their staked amount along with accumulated rewards. The contract implements essential staking functionality, including reward accrual based on time, owner-controlled parameters, and emergency withdrawal features.

The contract is deployed on a testnet using thirdweb.com and interacted with through MetaMask.

Key Features
Staking Functionality

Stake Tokens: Users can stake a specified amount of ERC-20 tokens into the contract.
Unstake Tokens: Users can withdraw their staked tokens, reducing their stake balance.
Reward System

Reward Accrual: Rewards are earned over time based on the amount of tokens staked and the duration of the stake.
Claim Rewards: Users can claim accumulated rewards at any time.
Reward Rate: The contract calculates rewards based on a rate set by the owner, expressed in terms of the staked token’s balance and the time elapsed.
Owner Functions

Emergency Withdrawal: The owner can withdraw the entire balance of staked tokens from the contract, useful for emergency situations.
Update Reward Rate: The owner can adjust the reward rate within a certain range.
Pause/Resume Contract: The contract can be paused and resumed by the owner, preventing staking, unstaking, and reward claims during maintenance or emergencies.
Security Features

Reentrancy Guard: The contract uses the ReentrancyGuard modifier to prevent reentrancy attacks during staking, unstaking, and reward claims.
Pause Contract: The contract includes pause functionality to halt all staking and reward operations, ensuring control during critical situations.
Key Variables
stakingToken: The ERC-20 token that users can stake.
owner: The owner of the contract, who can perform administrative functions.
rewardRate: The rate at which rewards are accumulated, specified as a multiplier for time and stake amount.
contractPaused: A boolean that tracks whether the contract is paused.
