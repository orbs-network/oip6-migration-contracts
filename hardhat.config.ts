import "dotenv/config";
import { HardhatUserConfig, task } from "hardhat/config";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-web3";
import "hardhat-gas-reporter";
import "hardhat-tracer";
import { askDeployer, askFees, deploy, hardhatDefaultConfig } from "@defi.org/web3-candies/dist/hardhat";
import _ from "lodash";
import "hardhat-watcher";
import "solidity-coverage";
import { deployOip6Migration } from "./deployment/deploy";
import { config } from "./deployment/config";

task("deploy-contract", "Deploy Excited contract").setAction(async (args, hre) => {
  const contractName = "Oip6Migration";

  console.log(`Running deployment script for ${contractName} contract...`);

  console.log("--------------------------------------");

  const deployer = process.env.DEPLOYER || (await askDeployer());
  const { max, tip } = await askFees();

  console.log("Deployer: ", deployer);
  console.log("Max fee: ", Number(max));
  console.log("Tip: ", Number(tip));


  if (!args.dry) {
    console.log("Deploying...");
    await deployOip6Migration(deploy, max, tip, hre.network.config.chainId!);
  }
});

export default _.merge(hardhatDefaultConfig(), {
  networks: {
    hardhat: {},
  },
  mocha: {
    bail: false,
  },
  watcher: {
    test: {
      tasks: ["test"],
    },
  },
} as HardhatUserConfig);
