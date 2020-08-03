require("dotenv").config();
jest.setTimeout(100000);

const { ethers } = require("ethers");
const erc20 = require("@studydefi/money-legos/erc20");

const MyDappArtifact = require("../build/contracts/MyDapp.json");

const fromWei = (x, u = 18) => ethers.utils.formatUnits(x, u);

describe("initial conditions", () => {
  let wallet, daiContract, myDapp;

  beforeAll(async () => {
    wallet = global.wallet;

    daiContract = new ethers.Contract(erc20.dai.address, erc20.dai.abi, wallet);

    myDapp = new ethers.Contract(
      MyDappArtifact.networks['1'].address,
      MyDappArtifact.abi,
      wallet,
    );
  });

  test("check ETH price in DAI is between 0 and 1000", async () => {
    const ethPriceWei = await myDapp.getEthPriceInDai();
    const ethPrice = parseFloat(fromWei(ethPriceWei));

    expect(ethPrice).toBeGreaterThan(0);
    expect(ethPrice).toBeLessThan(1000);
  });

  test("buy DAI from Uniswap via MyDapp", async () => {
    // confirm we have chainId of 1
    const network = await wallet.provider.getNetwork();
    expect(network.chainId).toBe(1);

    // collect info on state before the swap
    const ethBefore = await wallet.getBalance();
    const daiBefore = await daiContract.balanceOf(wallet.address);
    const ethPrice = await myDapp.getEthPriceInDai();

    // do the actual swapping
    await myDapp.swapEthToDai({
      gasLimit: 4000000,
      value: ethers.utils.parseEther("5"),
    });

    // collect info on state after the swap
    const ethAfter = await wallet.getBalance();
    const daiAfter = await daiContract.balanceOf(wallet.address);

    // check DAI gained
    const daiGained = parseFloat(fromWei(daiAfter.sub(daiBefore)));
    const expectedDaiGained = parseFloat(fromWei(ethPrice.mul(5)));
    expect(daiGained).toBeCloseTo(expectedDaiGained, 0);

    // check ETH lost
    const ethLost = parseFloat(fromWei(ethBefore.sub(ethAfter)));
    expect(ethLost).toBeCloseTo(5);
  });
});
