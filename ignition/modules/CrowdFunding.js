const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


const CrowdFundingModule = buildModule("CrowdFundingModule", (m) => {
  const token = m.contract("CrowdFunding");

  return { token };
});

module.exports = CrowdFundingModule;
