// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    error MoodNFT__CannotFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSVGImageURI,
        string memory happySVGImageURI
    ) ERC721("MooD NFT", "MDN") {
        s_sadSVGImageURI = sadSVGImageURI;
        s_happySVGImageURI = happySVGImageURI;
        s_tokenCounter = 0;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only want owner to change mood
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNFT__CannotFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns(string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }

        return 
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "', name(), '", "description": "An NFT that can change based on the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "', imageURI, '"}'
                            )
                        )
                    )
                )
            );
    }

}