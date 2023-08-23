/** @type import('hardhat/config').HardhatUserConfig */
// import "@nomicfoundation/hardhat-toolbox";
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require('dotenv').config();

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    bscTestnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      accounts: [process.env.BSC_PRIVATE_KEY]
    },
  },

  etherscan:{
    apiKey: {
      bscTestnet: process.env.BSC_API_KEY
    }
  }

};