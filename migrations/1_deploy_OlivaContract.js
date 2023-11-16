const OlivaContract = artifacts.require("OlivaContract");

module.exports = function(deployer){
    deployer.deploy(OlivaContract);
};