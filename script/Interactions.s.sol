// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "src/BasicNFT.sol";
import {MoodNFT} from "src/MoodNFT.sol";
import {DevOpsTools} from "@foundry-devops/src/DevOpsTools.sol";

contract MintBasicNFT is Script {
    string public constant cuteStar =
        "ipfs://Qmd1XMbbLSSybB4W4i3anjhbsbitWkBnLa4VTwAAM2sY13/?filename=star-metadata.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNFT(cuteStar);
        vm.stopBroadcast();
    }
}

contract MintMoodNFT is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT(contractAddress).mintNFT();
        vm.stopBroadcast();
    }
}

contract FlipMoodNFT is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNFT", block.chainid);
        flipNFTOnContract(mostRecentlyDeployed);
    }

    function flipNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT(contractAddress).flipMood(0);
        vm.stopBroadcast();
    }
}
