//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    constructor(){
        manager=msg.sender;
    }
    address payable[] public participants;

    receive()external payable {
        uint amt=msg.value/10**18;
        uint decimal=msg.value%10**18;
        require(amt>0,'enter valid amount');
               require(decimal==0,'enter valid amount');
               for(uint i;i<amt;i++){
                participants.push(payable(msg.sender));
               } 
    }
    // 2) more than 1 lottery can be bought and random floating eth will not be accepted

    function getBalance() public view returns(uint){
        require(msg.sender==manager,'not allowed');
        return address(this).balance;
    }           
  
    function winner() public view returns(address){
        require(participants.length>=3,'wait more participants');
       uint r=uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
       uint index=r%participants.length;
       return participants[index];
    }
    function transfermoney() public{
        address payable Winner=payable(winner());
        Winner.transfer(getBalance());
        participants=new address payable[](0);
    }
    
}
