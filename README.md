# Foundry Smart Contract Deployments (Lisk Sepolia)

This repository contains five smart contract projects developed using Foundry and deployed on the Lisk Sepolia Testnet.

## Projects and Deployment Addresses

| Project Name | Description | Contract Address |
|--------------|-------------|------------------|
| **ERC20 Token** | A standard implementation of the ERC20 token interface. | `0xb6530Fa0837d4bafC0CfAf1b833597A4Ea5b6525` |
| **Todo List** | A decentralized task management contract for CRUD operations. | `0x48b1fa5c94C63B38EbD9b49d5c0AFC2D01216186` |
| **SaveEther** | A simple savings contract for depositing and withdrawing ETH. | `0x3753d7cd7c072d38a0a506b6321d00e52fee44980dccc31fab6865f873612e7e` |
| **SaveAsset** | A multi-chain asset management contract for cross-chain savings. | `0x0FA078b33c34a18e564FcB746aDf37d48e40fda8` |
| **School Management** | A system to manage student records, payment, and teacher roles. | `0xAc916D00a5B5989Cea97f13f8f6E893F29fE3126` |

## Getting Started

### Prerequisites

Ensure you have Foundry installed:
```shell
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation

1. Clone the repository:
   ```shell
   git clone <repository-url>
   cd Smart-Contract-Week-Test
   ```

2. Install dependencies:
   ```shell
   forge install
   ```

### Compilation

To compile all contracts:
```shell
forge build
```

### Testing

To run the test suite:
```shell
forge test
```

### Deployment Command Template

To deploy any of these contracts to Lisk Sepolia, use the following command structure:

```shell
forge script script/<ScriptFile>.s.sol --rpc-url https://rpc.sepolia-api.lisk.com --private-key <YOUR_PRIVATE_KEY> --broadcast --verify
```

## Network Information: Lisk Sepolia
- **RPC URL:** `https://rpc.sepolia-api.lisk.com`
- **Chain ID:** `4202`
- **Currency Symbol:** `ETH`
- **Block Explorer:** `https://sepolia-blockscout.lisk.com`
