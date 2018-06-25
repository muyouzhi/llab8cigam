pragma solidity ^0.4.23;

import "./MagicToken.sol";


// Asker pays a token to ask questions
// User can answer a question assigned by the system to get a token 
contract MagicEightBall {
	struct Question {
		string questionText;
		bool isAnswered;
		string answerText;
	}

	MagicToken public tokenContract;
	uint currentId;
	uint lastUnansweredId;

	// Store questions by id
	mapping(uint => Question) questions;
	// List of user's questions
	mapping(address => uint[]) userQuestions;

	constructor(address tokenAddress) public {
		tokenContract = MagicToken(tokenAddress);
		lastUnansweredId = 0;
	}

	// Ask a question of `text`
	// @text question text
	function ask(string text) public returns (bool){
		require(notEmpty(text));
		if (tokenContract.balanceOf(msg.sender) >= 1) {
			tokenContract.destroyTokens(msg.sender, 1);
		}
		questions[currentId].questionText = text;
		userQuestions[msg.sender].push(currentId);
		currentId = currentId + 1;
		return true;
	}

	// Get question id of the question to be answered
	function getNextQuestionIdToAnswer() public returns (uint) {
		while (questions[lastUnansweredId].isAnswered) {
			lastUnansweredId = lastUnansweredId + 1;
		}
		return lastUnansweredId;
	}

	//  Get the question text of an unanswered question with id 'id'
	function getUnansweredQuestion(uint id) public view returns (string) {
		require(!questions[id].isAnswered);
		Question q = questions[id];
		return q.questionText;
	}

	// Get the answer of the question with id `id`
	function getAnswerForQuestion(uint id) public view returns (string) {
		require(questions[id].isAnswered);
		Question q = questions[id];
		return q.answerText;
	}

	// Get a list of questions
	function getMyQuestionIds() public view returns (uint[]) {
		return userQuestions[msg.sender];
	}


	// answer the question of id `questionId` with answer `text`
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

	// Check whether a string is empty
    function notEmpty(string text) public pure returns (bool) {
        bytes memory _content = bytes(text);
        return (_content.length != 0);
    }
}