// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract SavingsContract {
    
    address public tokenAddress;
    mapping(address => uint256) public ethBalance;
    mapping(address => uint256) public tokenBalance;

    event MoneyDeposited(address user, uint256 amount);
    event MoneyWithdrawn(address user, uint256 amount);

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function depositEth() external payable {
        require(msg.value > 0, "Must send some money");
        ethBalance[msg.sender] += msg.value;
        emit MoneyDeposited(msg.sender, msg.value);
    }

    function depositToken(uint256 amount) external {
        require(amount > 0, "Amount must be positive");
        bool success = IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");
        tokenBalance[msg.sender] += amount;
        emit MoneyDeposited(msg.sender, amount);
    }

    function withdrawEth(uint256 amount) external {
        require(ethBalance[msg.sender] >= amount, "Not enough balance");
        ethBalance[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send");
        emit MoneyWithdrawn(msg.sender, amount);
    }

    function withdrawToken(uint256 amount) external {
        require(tokenBalance[msg.sender] >= amount, "Not enough balance");
        tokenBalance[msg.sender] -= amount;
        bool success = IERC20(tokenAddress).transfer(msg.sender, amount);
        require(success, "Token transfer failed");
        emit MoneyWithdrawn(msg.sender, amount);
    }
}