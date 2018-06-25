var MagicToken = artifacts.require("MagicToken");

let magicTokenInstance;

contract('MagicToken', function(accounts) {
	it("Contract deployment", function() {
		return MagicToken.deployed().then(function (instance) {
			magicTokenInstance = instance;
			assert(magicTokenInstance !== undefined, "MagicToken contract should be defined.");
		});
	});

});