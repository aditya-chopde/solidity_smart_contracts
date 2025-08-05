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
    event Transfered(address indexed _to, uint256 _amt);

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
        uint256 bal = address(this).balance / 1 ether;
        return bal;
    }

    function withdraw(uint256 _amt) public {
        require(msg.sender == owner, "Only owner can withdraw the money");
        
        // Getting the amount available
        uint256 amount = address(this).balance;
        require(amount>0, "No funds to Withdraw");
        require(_amt < amount, "Insufficient Balance" );

        // The default _amt here is in Wei, so we need to convert it into Ether
        uint256 _amtEther = _amt*1 ether;

        // Getting the amount back from the contract
        payable(owner).transfer(_amtEther);
        emit Withdraw(owner, _amtEther);
    }

    function withdrawAll() public {
        uint256 amount = address(this).balance;

        require(amount>0, "No Funds to Transfer");

        payable(owner).transfer(amount);
        emit Withdraw(owner, amount);
    }

    function transwerFunds(address to, uint256 _amt) public {
        uint256 amountBal = address(this).balance;
        require(_amt<amountBal, "Insufficient Balance");
        require(amountBal>0, "No Funds to Transfer");
        uint256 finalAmt = _amt*1 ether;
        payable(to).transfer(finalAmt);
        emit Transfered(to, finalAmt);
    }
}