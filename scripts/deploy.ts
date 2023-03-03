import { ethers } from "hardhat";

async function main() {
  //10472
  const susId = 10472;
  const Lottery = await ethers.getContractFactory("Lottery");
  const lottery = await Lottery.deploy(susId);

  await lottery.deployed();

  console.log(
    `lottery deployed to ${lottery.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
