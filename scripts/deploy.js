
const hre = require("hardhat");

async function main() {




  const NFTContract = await hre.ethers.getContractFactory("BasicNft");
  const NFTdeployedContract = await NFTContract.deploy();

  await NFTdeployedContract.deployed();

  console.log("NFTContract Address :", NFTdeployedContract.address);

  const NFTMarketPlaceContract = await hre.ethers.getContractFactory("NFTMarketPlace");
  const NFTMarketPlaceContractdeploy = await NFTMarketPlaceContract.deploy();

  await NFTMarketPlaceContractdeploy.deployed();

  console.log("NFTMarketPlaceContractdeploy Address :", NFTMarketPlaceContractdeploy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
