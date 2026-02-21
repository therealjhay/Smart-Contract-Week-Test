// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {

    function name() public view returns (string);
    function symbol() public view returns (string);
    function decimals() public view returns (uint8);
    function totalSupply() public view returns (uint256);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

}

contract ERC20 {
    string constant NAME = "UnivToken";
    string constant SYMBOL = "Univt";
    uint8 constant DECIMAL = 18;
    uint256 constant TOTALSUPPLY = 2_000_000_000_000_000;

    uint256 public totalSupply;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


    function name() public view returns (string memory) {
        return NAME;
    }

    function symbol() public view returns (string memory) {
        return SYMBOL;
    }

    function decimals() public view returns (uint8){
        return DECIMAL;
    }

    function totalSupply() public view returns (uint256) {
        return TOTALSUPPLY;
        return total_supply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require()
    }

    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
}