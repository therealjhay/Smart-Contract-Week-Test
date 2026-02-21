// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SchoolManagement} from "../src/SchoolManagement.sol";

contract SchoolManagementScript is Script {
    SchoolManagement public schoolManagement;
    address private tokenAddr =0xb6530Fa0837d4bafC0CfAf1b833597A4Ea5b6525;
    
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        schoolManagement = new SchoolManagement(tokenAddr); 

        vm.stopBroadcast();
    }
}
