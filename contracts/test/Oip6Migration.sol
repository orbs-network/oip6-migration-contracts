// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwapContract is Ownable {
    using SafeERC20 for IERC20;
    IERC20 public newToken;
    IERC20 public oldToken;

    event Swapped(address indexed user, uint256 amount);

    constructor(address _newToken, address _oldToken) {
        newToken = IERC20(_newToken);
        oldToken = IERC20(_oldToken);
    }

    function depositNewToken(uint256 amount) external onlyOwner {
        newToken.safeTransferFrom(msg.sender, address(this), amount);
    }

    function swap(uint256 amount) external {
        safeTransferFrom(msg.sender, address(this), amount);
        require(newToken.balanceOf(address(this)) >= amount, "Not enough newToken in contract to perform swap");
        safeTransfer(msg.sender, amount);

        emit Swapped(msg.sender, amount);
    }

    function sendTokens(address token, address to, uint256 amount) external onlyOwner {
        IERC20 erc20Token = IERC20(token);
        require(erc20Token.balanceOf(address(this)) >= amount, "Not enough tokens in contract to perform send");
        safeTransfer(to, amount);
    }
}
