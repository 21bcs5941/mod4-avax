// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct NFTData {
        uint256 id;
        string name;
        uint256 amount;
    }

    mapping(uint256 => NFTData) private nftData;
    uint256 private totalNFTs;

    event NFTAdded(uint256 indexed id, string name, uint256 amount);
    event NFTRedeemed(uint256 indexed id, address indexed redeemer, uint256 amount);

    constructor() ERC20("Degen", "DGN") {
        _addNFT("ProPlayer NFT value", 200);
        _addNFT("SuperNinja value", 100);
        _addNFT("DegenCap value", 75);
    }

    function _addNFT(string memory name, uint256 amount) internal {
        totalNFTs++;
        nftData[totalNFTs] = NFTData(totalNFTs, name, amount);
        emit NFTAdded(totalNFTs, name, amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, receiver, amount);
    }

    function burnTokens(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function gameStore() public view returns (NFTData[] memory) {
        NFTData[] memory availableNFTs = new NFTData[](totalNFTs);
        for (uint256 i = 1; i <= totalNFTs; i++) {
            availableNFTs[i - 1] = nftData[i];
        }
        return availableNFTs;
    }

    function addNFT(string memory name, uint256 amount) public onlyOwner {
        _addNFT(name, amount);
    }

    function redeemTokens(uint256 choice) external {
        require(choice >= 1 && choice <= totalNFTs, "Invalid selection");

        NFTData memory selectedNFT = nftData[choice];
        uint256 tokenAmount = selectedNFT.amount;
        require(balanceOf(msg.sender) >= tokenAmount, "Insufficient balance");

        _transfer(msg.sender, owner(), tokenAmount);
        delete nftData[choice];
        emit NFTRedeemed(choice, msg.sender, tokenAmount);
    }
}
