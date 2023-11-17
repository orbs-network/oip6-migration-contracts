import { ConfigTuple } from "./config";
import BN from "bignumber.js";
import { DeployParams } from "@defi.org/web3-candies/dist/hardhat";
import { erc20 } from "@defi.org/web3-candies";

// TODO VERIFY!

const chainsById: Record<number, string> = {
  43114: "AVA",
  250: "FTM",
  56: "BSC",
};

const oldTokens: Record<string, string> = {
  AVA: "0x340fe1d898eccaad394e2ba0fc1f93d27c7b717a",
  FTM: "0x3e01b7e242d5af8064cb9a8f9468ac0f8683617c",
  BSC: "0xebd49b26169e1b52c04cfd19fcf289405df55f80",
};

const newTokens: Record<string, string> = {
  AVA: "0x3Ab1C9aDb065F3FcA0059652Cd7A52B05C98f9a9",
  FTM: "0x43a8cab15D06d3a5fE5854D714C37E7E9246F170",
  BSC: "0x43a8cab15D06d3a5fE5854D714C37E7E9246F170",
};

export const deployOip6Migration = async (deploy: (params: DeployParams) => Promise<string>, maxFeePerGas: BN, maxPriorityFeePerGas: BN, chainId: number) => {
  if (!Object.keys(chainsById).includes(String(chainId))) throw new Error("Chain not supported: " + chainId);

  console.log("Deploying on " + chainsById[chainId]);
  const oldToken = oldTokens[chainsById[chainId]];
  const newToken = newTokens[chainsById[chainId]];

  console.log(`Old token: ${oldToken}; New token: ${newToken}`);

  const oldDecimals = await erc20("Old", oldToken).decimals();
  const newDecimals = await erc20("New", newToken).decimals();

  if (oldDecimals !== newDecimals) throw new Error("Decimals have to be similar");

  await deploy({
    contractName: "Oip6Migration",
    args: [oldToken, newToken],
    maxFeePerGas: maxFeePerGas,
    maxPriorityFeePerGas: maxPriorityFeePerGas,
  });
};
