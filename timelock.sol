//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract timelock {

    uint public current_timestamp = block.timestamp;

    mapping(address => uint) public balance;
    mapping(address => uint) public timebalance;

    function deposit(uint _timetolockinsec) payable public returns (bool success) {
        require(_timetolockinsec > 0,"Invalid Time in sec");
        if(msg.value > 0) {
            timebalance[msg.sender] = block.timestamp + _timetolockinsec;
            balance[msg.sender] += msg.value;
            return true;
        } 
        else false;
    }

    //withdraw function withdraws all ether at once, given the deposit has been unlocked
    function withdraw() public {
        require(balance[msg.sender] > 0,"Nothing to withdraw");
        require(timebalance[msg.sender] < block.timestamp,"Deposit is still locked");
        uint x = balance[msg.sender];
        balance[msg.sender] = 0;
        timebalance[msg.sender] = 0;

        payable(msg.sender).transfer(x);
    }


}
