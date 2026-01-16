// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ryuCoin {
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    address public owner;
    uint8 public decimals;

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) public allowance;

    address public kenCoinAddress;

    constructor(address _kenCoinAddress) {
        name = "RyuCoin";
        symbol = "RYU";
        decimals = 18;

        kenCoinAddress = _kenCoinAddress;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
            return helperTransfer(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
            allowance[msg.sender][spender] = amount;

            return true;
    }

    function trade(uint256 amount) public {
        (bool ok, bytes memory result) = kenCoinAddress.call(
            abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                msg.sender,
                address(this),
                amount
            )
        );
        require(ok, "call failed");
        
        // minting approvoed tokens ehre
        totalSupply += amount;
        balanceOf[msg.sender] += amount;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
            if (msg.sender != from) {
                require(allowance[from][msg.sender] >= amount,
                    "not enough allowance");

                allowance[from][msg.sender] -= amount;
            }
            return helperTransfer(from, to, amount);
    }

    function helperTransfer(address from, address to, uint256 amount) internal returns (bool) {
            require(balanceOf[from] >= amount,
                "not enough money");
            require(to != address(0),
                "cannot send to address(0)");
            balanceOf[from] -= amount;
            balanceOf[to] += amount;

            return true;
    }
}