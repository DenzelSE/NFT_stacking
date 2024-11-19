// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTStaking {
    IERC721 public nftToken;
    mapping(uint256 => address) public stakers;
    mapping(uint256 => uint256) public stakingTime;

    constructor(address _nftToken) {
        nftToken = IERC721(_nftToken);
    }

    function stake(uint256 _tokenId) external {
        require(nftToken.ownerOf(_tokenId) == msg.sender, "Not the owner");
        stakers[_tokenId] = msg.sender;
        stakingTime[_tokenId] = block.timestamp;
        nftToken.transferFrom(msg.sender, address(this), _tokenId);
    }

    function unstake(uint256 _tokenId) external {
        require(stakers[_tokenId] == msg.sender, "Not the staker");
        nftToken.transferFrom(address(this), msg.sender, _tokenId);
        delete stakers[_tokenId];
        delete stakingTime[_tokenId];
    }

    function calculateRewards(uint256 _tokenId) public view returns (uint256) {
        return (block.timestamp - stakingTime[_tokenId]) * 1 ether;
    }
}