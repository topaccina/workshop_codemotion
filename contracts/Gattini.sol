//SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Gattini is ERC721, Ownable {
    uint256 public tokenCounter = 0;
    string private baseURI;
    uint256 public tokenPrice = 0.01 ether;

    uint256 public constant MAX_SUPPLY = 200;

    constructor(string memory _baseTokenURI) ERC721("Gattini", "MIAO") {
        baseURI = _baseTokenURI;
    }

    function mint(uint256 _mintAmount) external payable {
        require(
            tokenCounter + _mintAmount <= MAX_SUPPLY,
            "max supply exceeded"
        );
        require(msg.value >= tokenPrice * _mintAmount, "not enough ETH");
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, tokenCounter + i);
        }

        tokenCounter += _mintAmount;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function whitdraw() external onlyOwner {
        address payable wallet = payable(msg.sender);
        uint256 balance = address(this).balance;
        wallet.transfer(balance);
    }
}
