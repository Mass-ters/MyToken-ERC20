// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/**
 * ERC-20 simple pour l'exercice.
 */
contract MyToken is IERC20 {

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 private _totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        name = "MyToken";
        symbol = "MYT";
        decimals = 18;

        owner = msg.sender;

        uint256 supply = 1_000_000 * (10 ** decimals);
        _totalSupply = supply;
        balanceOf[msg.sender] = supply;

        emit Transfer(address(0), msg.sender, supply);
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        require(msg.sender != address(0), "zero address");
        require(recipient != address(0), "zero address");
        require(balanceOf[msg.sender] >= amount, "balance too low");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        external
        override
        returns (bool)
    {
        require(spender != address(0), "zero address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        require(sender != address(0), "zero sender");
        require(recipient != address(0), "zero recipient");
        require(balanceOf[sender] >= amount, "balance too low");

        uint256 allowed = allowance[sender][msg.sender];
        require(allowed >= amount, "allowance too low");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] = allowed - amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external returns (bool) {
        require(msg.sender == owner, "not owner");

        _totalSupply += amount;
        balanceOf[owner] += amount;

        emit Transfer(address(0), owner, amount);
        return true;
    }

    function burn(uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "balance too low");

        balanceOf[msg.sender] -= amount;
        _totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
}
