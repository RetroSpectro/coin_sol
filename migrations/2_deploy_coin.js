let Coin = artifacts.require("Coin");
let Pool = artifacts.require("Pool");
module.exports = function(deployer, network, accounts) {
    deployer.deploy(Coin, { from: accounts[0] });
    deployer.deploy(Pool, { from: accounts[0] });
};