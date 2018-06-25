var MagicToken = artifacts.require("MagicToken");
var MagicEightBall = artifacts.require("MagicEightBall");
var Controlled = artifacts.require("Controlled");

module.exports = function(deployer) {
	deployer.deploy(Controlled);
	deployer.deploy(MagicToken).then((instance) => {
		console.log(instance);
		deployer.deploy(MagicEightBall, instance.address);
	});
};