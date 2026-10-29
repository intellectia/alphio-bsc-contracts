# Alphio BSC Contracts

On-chain contracts for [Alphio.AI](https://alphio.ai), an AI-powered trading app, built on **BNB Smart Chain (BSC)**.

Alphio users trade BSC tokens (including PancakeSwap-listed meme tokens) from embedded wallets in the Alphio app. This repository holds Alphio's own contracts deployed on BNB Smart Chain.

## Technology Stack

- **Blockchain**: BNB Smart Chain (BSC)
- **Smart Contracts**: Solidity 0.8.24
- **Development**: Foundry (forge, cast)

## Supported Networks

- **BNB Smart Chain Mainnet** (Chain ID: 56)
- **BNB Smart Chain Testnet** (Chain ID: 97)

RPC endpoints are configured in [`foundry.toml`](foundry.toml); deployed addresses are recorded in [`deployments/bsc.json`](deployments/bsc.json).

## Contract Addresses

| Network | AlphioCheckIn |
|---------|---------------|
| BNB Mainnet (56) | [`0x699746D07BD42A86E04783B74B951Ed1c8129eDb`](https://bscscan.com/address/0x699746D07BD42A86E04783B74B951Ed1c8129eDb) |
| BNB Testnet (97) | — |

## Contracts

### `AlphioCheckIn`

Daily on-chain check-in for Alphio users on BNB Smart Chain. Any address can call `checkIn()` once per UTC day; each call emits `CheckedIn(user, day, count)` so activity is indexable.

- No owner, no admin, no upgradeability
- Non-payable: plain BNB transfers and value-bearing calls revert
- Makes no external calls and never holds funds

## Features

- Daily check-in for Alphio users on BNB Smart Chain
- Permissionless and immutable: no privileged roles after deployment
- Minimal storage and a single event per check-in, keeping BSC gas costs low

## Development

```bash
git clone --recurse-submodules https://github.com/intellectia/alphio-bsc-contracts.git
cd alphio-bsc-contracts
forge build
forge test
```

## Deploy to BNB Smart Chain

```bash
# import the deployer key into a Foundry keystore (never pass it as an env var)
cast wallet import alphio-bsc-deployer --interactive

# dry-run, then broadcast
forge script script/DeployBscCheckIn.s.sol --rpc-url bsc --account alphio-bsc-deployer -vv
forge script script/DeployBscCheckIn.s.sol --rpc-url bsc --account alphio-bsc-deployer --broadcast
```

Verify on [BscScan](https://bscscan.com) via *Verify & Publish → Solidity (Standard-Json-Input)*:

```bash
forge verify-contract <address> src/AlphioCheckIn.sol:AlphioCheckIn --chain 56 --show-standard-json-input > AlphioCheckIn.json
```

## License

[MIT](LICENSE)
