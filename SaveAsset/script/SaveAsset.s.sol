// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SaveAsset} from "../src/SaveAsset.sol";

contract SaveAssetScript is Script {
    SaveAsset public saveAsset;
    address private tokenAddr =0xb6530Fa0837d4bafC0CfAf1b833597A4Ea5b6525;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        saveAsset = new SaveAsset(tokenAddr);

        vm.stopBroadcast();
    }
}
