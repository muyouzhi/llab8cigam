pragma solidity ^0.4.23;

import "./MagicToken.sol";

// Controlls the issuance of MagicToken

contract MagicEightBall {
	struct Question {
	 	uint id;
		string questionText;
		string answerText;
	}

	MagicToken public tokenContract;
	uint currentId;
	uint lastUnansweredId;
	mapping(uint => Question) questions;

	constructor(address tokenAddress) public {
		tokenContract = MagicToken(tokenAddress);
		lastUnansweredId = 0;
	}

	function ask(string text) public returns (bool){
		require(notEmpty(text));
		if (tokenContract.balanceOf(msg.sender) >= 1) {
			tokenContract.destroyTokens(msg.sender, 1);
		}
		questions[currentId].questionText = text;
		currentId = currentId + 1;
		return true;
	}

	function getNextQuestionIdToAnswer() public view returns (uint) {
		return lastUnansweredId;
	}

	function getUnansweredQuestion() public view returns (uint) {
		return lastUnansweredId;
	}

	function getAnswerForQuestion(uint id) public view returns (string) {
		Question q = questions[id];
		require(notEmpty(q.answerText));
		return q.answerText;
	}

	function answer(uint questionId, string text) public returns (bool){
		require(notEmpty(text));
		require(!notEmpty(questions[questionId].answerText));
		questions[questionId].answerText = text;
		lastUnansweredId = lastUnansweredId + 1;

		// reward the answerer
		tokenContract.generateTokens(msg.sender, 1);
		return true;
	}

    function notEmpty(string text) public pure returns (bool) {
        bytes memory _content = bytes(text);
        return (_content.length != 0);
    }
}