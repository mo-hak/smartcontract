//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract crowdfunding{
     address manager;
     uint deadline;
     uint target;
     mapping(address=>uint) contributors;
     uint public noOfContributor;
     uint totalColected;
     uint numrequest;

    constructor(uint _target,uint _deadline){
    manager=msg.sender;
    target=_target;
    deadline = _deadline + block.timestamp;
    }

    struct Request{
      bytes32 description;
      address payable recipient;
      uint value;
      bool completed;
      uint noOfVoters;
      mapping(address=>bool) voters;
    }

    mapping(uint=>Request) requests;
    modifier onlyManager() {
      require(msg.sender == manager,"Only Manager allowed");
      _;
   } 
    function createRequest(bytes32 _description,address payable _recipient, uint _value) public onlyManager{
        requests[numrequest].description=_description;
        requests[numrequest].recipient=_recipient;
        requests[numrequest].value=_value;
        requests[numrequest].noOfVoters=0;
        requests[numrequest].completed=false;
        numrequest++;
    }
    function senEth() public payable {
        require(block.timestamp<deadline,"expired !!");
        if(contributors[msg.sender]==0){
            noOfContributor++;
        }
         contributors[msg.sender]+=msg.value;
        totalColected+=msg.value;
    }
    function refund() public {
     require(block.timestamp>deadline,"not expired yet !!");
     require(contributors[msg.sender]!=0 && totalColected<target,"Not allowed");
     address payable user= payable(msg.sender);
     user.transfer(contributors[msg.sender]);
     contributors[msg.sender]=0;
    }
    function getBalance()public view returns(uint){
        return address(this).balance;
    }
    function voting(uint noRequest) public{
        require(contributors[msg.sender]!=0,"you are not a contributor");
        require(requests[noRequest].voters[msg.sender]=false,"You have already voted");
        requests[noRequest].noOfVoters++;
        requests[noRequest].voters[msg.sender]=true;
    }
    function transferEth(uint _noRequest) public onlyManager{
        require(totalColected>=requests[_noRequest].value,"get a life duhh.");
        require(requests[_noRequest].completed==false,"already transfered");
        require(requests[_noRequest].noOfVoters>noOfContributor/2,"majority wants to raise fund.");
        requests[_noRequest].recipient.transfer(requests[_noRequest].value);
        requests[_noRequest].completed==true;
    }
}
