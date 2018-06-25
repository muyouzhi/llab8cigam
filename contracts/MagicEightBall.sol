pragma solidity ^0.4.23;

import "./MagicToken.sol";

// Controlls the issuance of MagicToken

contract MagicEightBall {
	struct Question {
		string questionText;
		bool isAnswered;
		string answerText;
	}

	MagicToken public tokenContract;
	uint currentId;
	uint lastUnansweredId;
	mapping(uint => Question) questions;
	mapping(address => uint) userQuestions;

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
		userQuestions[msg.sender] = currentId;
		currentId = currentId + 1;
		return true;
	}

	function getNextQuestionIdToAnswer() public view returns (uint) {
		return lastUnansweredId;
	}

	function getUnansweredQuestion(uint id) public view returns (string) {
		require(!questions[id].isAnswered);
		Question q = questions[id];
		return q.answerText;
	}

	function getAnswerForMyQuestion() public view returns (string) {
		uint id = userQuestions[msg.sender];
		if (id != 0) {
			Question q = questions[id];
			require(notEmpty(q.answerText));
			return q.answerText;
		}
	}

	function answer(uint questionId, string text) public returns (bool){
		require(notEmpty(text));
		require(!notEmpty(questions[questionId].answerText));
		questions[questionId].answerText = text;
		questions[questionId].isAnswered = true;
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