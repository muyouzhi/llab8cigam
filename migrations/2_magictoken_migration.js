var MagicToken = artifacts.require("MagicToken");
var MagicEightBall = artifacts.require("MagicEightBall");

module.exports = function(deployer) {
	deployer.deploy(Controlled);
	deployer.deploy(MagicToken).then((instance) => {
		console.log(instance);
		deployer.deploy(MagicEightBall, instance.address);
	});
};