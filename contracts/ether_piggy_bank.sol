// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherPiggyBank{
    address public owner;
    // Note:- Everything which is payable can get the eth by clicking on it 
    constructor(){
        owner = msg.sender;
    }

    event Deposited(address indexed _owner, uint256 _amt);
    event Withdraw(address indexed _owner, uint256 _amt);

    modifier onlyOwner() {
        require(msg.sender==owner, "Only owner can access this function");
        _;
    }

    // Receiving Ether through direct Value 
    receive() external payable { 
        emit Deposited(owner, msg.value);
    }

    // Everything which is payable can take money as a value 
    function deposit() external payable{
        require(msg.value > 0, "Deposit amount must be greater than zero"); // added for security)
        emit Deposited(owner, msg.value);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function withdraw() public {
        // Getting teh amount available
        uint256 amount = address(this).balance;
        require(amount>0, "No funds to Withdraw");

        // Getting the amount back from the contract
        payable(owner).transfer(amount);
        emit Withdraw(owner, amount);
    }
}