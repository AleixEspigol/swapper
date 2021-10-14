const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Swapper", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Swapper = await ethers.getContractFactory('Swapper');
    const swapper = await Swapper.deploy(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
    await swapper.deployed();

    const balanceFromToken = await swapper.balanceOf(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063);
    const balanceToToken = await swapper.balanceOf(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);

    expect(await swapper.swap()).to.equal(balanceToToken);

    // wait until the transaction is mined
    await swapper.wait();
  });
});
