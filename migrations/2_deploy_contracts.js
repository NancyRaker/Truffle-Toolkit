const MyDapp = artifacts.require("MyDapp");

module.exports = function (deployer) {
  deployer.deploy(MyDapp);
};
