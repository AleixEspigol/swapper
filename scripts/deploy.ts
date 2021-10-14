import { run, ethers } from 'hardhat';
​
async function main() {
  run('compile');
  const Swapper = await ethers.getContractFactory('Swapper');
  const swapper = await Swapper.deploy(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
  console.log('Swapper deployed to:', swapper.address);
}
​
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
