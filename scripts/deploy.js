// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Obj = await hre.ethers.getContractFactory("UniswapV2Router02");
  const router = await Obj.deploy(
	  "0xfB708228644328c43407Cc3350bbEFbAAb46FcAF",
  	  "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd",
  );

  await router.deployed();

  console.log("Router02 deployed to:", router.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
