//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;


contract MessageStorage {
    struct Message {
        string name;
        address sender;
        uint amount;
        string message;
    }

    Message[] public messages;

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function sendMessage(string calldata _name, string calldata _message) public payable {
        require(msg.value > 0, "Please send some ether along with the message.");

        uint amount = msg.value;
        Message memory newMessage = Message(_name, msg.sender, amount, _message);
        messages.push(newMessage);

    }

    function getMessageCount() public view returns (uint) {
        return messages.length;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        require(address(this).balance > 0, "No balance available to withdraw.");

        uint256 balance = address(this).balance;
        owner.transfer(balance);

    }

    function getMessage(uint index) public view returns (Message memory) {
        require(index < messages.length, "Invalid message index.");
        return messages[index];
    }
}
