import { ethers } from "hardhat";

async function main() {
  const Voting = await ethers.getContractFactory("Voting");
  const voting = Voting.attach("0x9e4b290B77823d42D1BF07e5A0b94A7C0bd13393");


  const voter = "0x7Bd5f674D8D82286d10B75d63CF18ea3c45d2AbD";
//   const giveRight = await voting.giveRightToVote(voter);
//   const giveRightReciept = await giveRight.wait();

  const vote = voting.vote(1);
  const voteReciept = await vote.wait();

  console.log(`vote reciept : ${voteReciept}`);

}

// contract address rinkeby : 0x9e4b290B77823d42D1BF07e5A0b94A7C0bd13393

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
