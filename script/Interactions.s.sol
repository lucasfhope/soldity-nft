// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "src/BasicNFT.sol";
import {DevOpsTools} from "@foundry-devops/src/DevOpsTools.sol";

contract MintBasicNFT is Script {
    string public constant cuteStar = "ipfs://Qmd1XMbbLSSybB4W4i3anjhbsbitWkBnLa4VTwAAM2sY13?filename=star-metadata.json"; 

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNFT(cuteStar);
        vm.stopBroadcast();
    } 
}