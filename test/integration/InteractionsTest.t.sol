//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "src/BasicNFT.sol";
import {DeployBasicNFT} from "script/DeployBasicNFT.s.sol";
import {MintBasicNFT} from "script/Interactions.s.sol";

contract FundMeTestInteractions is Test {
    BasicNFT basicNFT;

    address USER = makeAddr("user");
    uint256 constant STARTING_AMT = 10 ether;

    function setUp() external {
        DeployBasicNFT deployBasicNFT = new DeployBasicNFT();
        basicNFT = deployBasicNFT.run();
        vm.deal(USER, STARTING_AMT);
    }

    function testMintBasicNFTInteraction() public {
        MintBasicNFT mintBasicNFT = new MintBasicNFT();
        mintBasicNFT.mintNFTOnContract(address(basicNFT));

        address expectedOwner = address(msg.sender);
        assertEq(basicNFT.ownerOf(0), expectedOwner);
        assertEq(basicNFT.tokenURI(0), mintBasicNFT.cuteStar());
        assertEq(basicNFT.balanceOf(expectedOwner), 1);
    }
}
