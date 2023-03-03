// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Lottery is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId;
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    bytes32 s_keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 40000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;
    address s_owner;

    mapping(address => bool) public players;
    address[] public playerList;

    event RequestedRandomness(bytes32 requestId);

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    function enter() public payable {
        require(
            msg.value > 0,
            "You need to send some ether to enter the lottery!"
        );
        require(
            !players[msg.sender],
            "You are already entered in the lottery!"
        );

        players[msg.sender] = true;
        playerList.push(msg.sender);
    }

    function pickWinner() public onlyOwner {
        require(playerList.length > 0, "There are no players in the lottery!");
        COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {
        uint256 index = randomWords[0] % playerList.length;

        address payable winner = payable(playerList[index]);
        winner.transfer(address(this).balance);

        playerList = new address[](0);
    }
}
