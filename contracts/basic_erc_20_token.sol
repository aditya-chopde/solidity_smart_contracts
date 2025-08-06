// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract BasicToken20 {
    // Stare Variables
    string public name = "BasicERCToken";
    string public symbol = "BSC";
    uint256 public decimals = 18;
    uint256 public totalSupply;

    // Maps addresses to their balances
    mapping(address => uint256) public balanceOf;

    // Maps owner => (spender => allowance)
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed minter, uint256 amount);
    event Burn(address indexed burner, uint256 amount);
    
    // Transfer tokens to another address
    function transferFunds(address _to, uint256 _amt) public returns(bool){
        require(balanceOf[msg.sender]>0, "No Funds to Transfer");
        require(balanceOf[msg.sender]<_amt, "Insufficient Funds");

        balanceOf[msg.sender] -= _amt;
        balanceOf[_to] += _amt;

        emit Transfer(msg.sender, _to, _amt);
        return true;
    }

    // Approve someone to spend tokens on your behalf
    function approve(address _spender, uint256 _amt) public returns(bool){
        require(_spender != address(0), "Invalid address");
        require(balanceOf[msg.sender]>=_amt, "Insufficient Funds");

        allowance[msg.sender][_spender] = _amt;

        emit Approval(msg.sender, _spender, _amt);
        return true;
    }

    // Transfer from someone else (with allowance)
    function transferFrom(address from, address to, uint256 amt) public returns(bool){
        require(balanceOf[from]>=amt, "Insufficient Funds");
        require(allowance[from][msg.sender]>=amt, "Alownace Exceeded"); // The msg.sender is allowed to be as a spender

        balanceOf[from] -= amt;
        balanceOf[to] += amt;
        allowance[from][msg.sender] -= amt;

        emit Transfer(from, to, amt);
        return true;
    }

    // Mint new tokens to the caller
    function mint(uint256 _amt) public returns(bool){
        balanceOf[msg.sender] += _amt;
        totalSupply += _amt;

        emit Mint(msg.sender, _amt);
        emit Transfer(address(0), msg.sender, _amt);
        return true;
    }

    // Burn your own tokens
    function burn(uint256 amount) public returns(bool){
        require(balanceOf[msg.sender]>=amount, "Insufficient Funds");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
        emit Burn(msg.sender, amount);
        return true;
    }

    function getSender() public view returns(address){
        return msg.sender;
    }
}
