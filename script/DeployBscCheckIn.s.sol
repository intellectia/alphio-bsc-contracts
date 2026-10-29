// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {AlphioCheckIn} from "../src/AlphioCheckIn.sol";

/// @notice Plain CREATE deploy of AlphioCheckIn to BNB Smart Chain (chainId 56;
/// testnet 97 via `--rpc-url bsc_testnet`).
/// No constructor args, no post-deploy setup: the deployer has no
/// privileges afterwards, so a fresh single-purpose wallet is enough.
///
/// Key goes through a Foundry keystore, never an env var:
///   cast wallet import alphio-bsc-deployer --interactive
///
/// Run (dry-run, no broadcast):
///   forge script script/DeployBscCheckIn.s.sol --rpc-url bsc --account alphio-bsc-deployer -vv
///
/// Run (real deploy):
///   forge script script/DeployBscCheckIn.s.sol --rpc-url bsc --account alphio-bsc-deployer --broadcast
///
/// Verify on BscScan (web UI, free): generate the Standard-JSON input and
/// upload it at bscscan.com → Verify & Publish → Solidity (Standard-Json-Input):
///   forge verify-contract <addr> src/AlphioCheckIn.sol:AlphioCheckIn --chain 56 --show-standard-json-input > AlphioCheckIn.json
/// Then record the address in deployments/bsc.json and README.md.
contract DeployBscCheckIn is Script {
    function run() external returns (AlphioCheckIn checkIn) {
        require(block.chainid == 56 || block.chainid == 97, "BSC mainnet/testnet only");
        console.log("chainId:", block.chainid);

        vm.startBroadcast();
        checkIn = new AlphioCheckIn();
        vm.stopBroadcast();

        console.log("AlphioCheckIn:", address(checkIn));
    }
}
