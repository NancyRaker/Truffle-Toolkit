const UniswapLiteBase = artifacts.require("UniswapLiteBase");

module.exports = function(deployer) {
  deployer.deploy(UniswapLiteBase);
};
