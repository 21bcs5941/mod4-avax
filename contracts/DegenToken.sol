// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    constructor() ERC20("Degen", "DGN") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address _receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Your account balance is not sufficient");
        transfer(_receiver, amount);
    }

    function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }

    function redeemTokens(uint choice) external payable {
        require(choice >= 1 && choice <= 3, "Choice should be in between 1 to 3");

        if (choice == 1) {
            require(balanceOf(msg.sender) >= 200, "Insufficient balance");
            _transfer(msg.sender, owner(), 200);
        } else if (choice == 2) {
            require(balanceOf(msg.sender) >= 100, "Insufficient balance");
            _transfer(msg.sender, owner(), 100);
        } else {
            require(balanceOf(msg.sender) >= 75, "Insufficient balance");
            _transfer(msg.sender, owner(), 75);
        }
    }

    function gameStore() external pure returns (string memory) {
        return "1. ProPlayer NFT value = 200\n2. SuperNinja value = 100\n3. DegenCap value = 75";
    }
}
