// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "src/BasicNFT.sol";
import {DeployBasicNFT} from "script/DeployBasicNFT.s.sol";
import {MintBasicNFT} from "script/Interactions.s.sol";

contract BasicNFTTest is Test {
    DeployBasicNFT deployer;
    BasicNFT basicNFT;
    MintBasicNFT mintBasicNFT;

    address public USER = makeAddr("user");
    string public constant cuteStar =
        "ipfs://Qmd1XMbbLSSybB4W4i3anjhbsbitWkBnLa4VTwAAM2sY13?filename=star-metadata.json";

    // event emitted by ERC721.sol during token transfer
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        bytes32 expectedNameHash = keccak256(abi.encodePacked("Cute star"));
        bytes32 actualNameHash = keccak256(abi.encodePacked(basicNFT.name()));
        assert(expectedNameHash == actualNameHash);
    }

    function testSymbolIsCorrect() public view {
        bytes32 expectedSymbolHash = keccak256(abi.encodePacked("STAR"));
        bytes32 actualSymbolHash = keccak256(abi.encodePacked(basicNFT.symbol()));
        assert(expectedSymbolHash == actualSymbolHash);
    }

    function testCanMintAndHasBalance() public {
        vm.prank(USER);
        basicNFT.mintNFT(cuteStar);

        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(cuteStar)) == keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
    }

    // Test that minting multiple NFTs increments token IDs and balances
    function testMintingMultipleTokensIncrementsTokenIdAndHasTheCorrectBalance() public {
        vm.prank(USER);
        basicNFT.mintNFT(cuteStar);
        vm.prank(USER);
        basicNFT.mintNFT(cuteStar);

        assertEq(basicNFT.balanceOf(USER), 2);
        assertEq(keccak256(abi.encodePacked(basicNFT.tokenURI(1))), keccak256(abi.encodePacked(cuteStar)));
    }

    function testTokenURIRevertsForNonExistentTokenDuringTransfer() public {
        address scott = makeAddr("scott");

        // no token has been minted yet
        vm.expectRevert();
        vm.prank(USER);
        basicNFT.transferFrom(USER, scott, 0);
    }

    function testTransferNFT() public {
        address scott = makeAddr("scott");

        vm.prank(USER);
        basicNFT.mintNFT(cuteStar);
        uint256 tokenId = 0;

        vm.prank(USER);
        basicNFT.transferFrom(USER, scott, tokenId);

        assertEq(basicNFT.balanceOf(USER), 0);
        assertEq(basicNFT.balanceOf(scott), 1);
        assertEq(keccak256(abi.encodePacked(basicNFT.tokenURI(tokenId))), keccak256(abi.encodePacked(cuteStar)));
    }

    function testMintEmitsTransferEvent() public {
        // Expect Transfer event: from the zero address to USER for tokenId 0
        vm.prank(USER);
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), USER, 0);
        basicNFT.mintNFT(cuteStar);
    }
}
