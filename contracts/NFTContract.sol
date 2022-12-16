// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract BasicNft is ERC721 {
    string public constant TOKEN_URI =
        "ipfs://bafybeiadxvfjxuigs3vyoh36bf3yjnahw3sxlgwn36or5iehofxm4o3xxa/";
    uint256 private s_tokenCounter;

    event NFTMinted(uint256 indexed tokenId);

    constructor() ERC721("DUKE", "KTM") {
        s_tokenCounter = 0;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        emit NFTMinted(s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return TOKEN_URI;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}