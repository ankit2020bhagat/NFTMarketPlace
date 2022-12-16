require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
     url: process.env.MUMBAI_API_KEY_URL,
     accounts: [process.env.PRIVATE_KEY],
     },
     goerli: {
       url:  process.env.GOERLI_API_KEY_URL,
       accounts: [process.env.PRIVATE_KEY],
      
     },
     hardhat:{
       chainId:31337,
   },
  
 },
 etherscan: {
   // Your API key for Etherscan
   // Obtain one at https://etherscan.io/

   apiKey: process.env.ETHER_SCAN_API,
 }
};
