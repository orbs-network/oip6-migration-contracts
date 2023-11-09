// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Oip6Migration is Ownable {
    using SafeERC20 for IERC20;
    IERC20 public newToken;
    IERC20 public oldToken;
    error NotEnoughNewTokens(uint256 missing);
    event Swapped(address indexed user, uint256 amount);

    constructor(address _oldToken, address _newToken) {
        oldToken = IERC20(_oldToken);
        newToken = IERC20(_newToken);
    }

    function swap(uint256 amount) external {
        oldToken.safeTransferFrom(msg.sender, address(this), amount);
        uint256 balance = newToken.balanceOf(address(this));
        if (balance < amount) revert NotEnoughNewTokens(amount - balance);
        newToken.safeTransfer(msg.sender, amount);

        emit Swapped(msg.sender, amount);
    }

    function sendTokens(address token, address to, uint256 amount) external onlyOwner {
        IERC20 erc20Token = IERC20(token);
        erc20Token.safeTransfer(to, amount);
    }
}
