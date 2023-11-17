# Orbs OIP6 migration contract
This contract allows migration of the defunct multichain-bridged Orbs token to Axelar-bridged token in the following networks:

| Network   | Old token address (Multichain)             | New token address (Axelar)                 | Migration contract address |
|-----------|--------------------------------------------|--------------------------------------------|----------------------------|
| BNB       | 0xebd49b26169e1b52c04cfd19fcf289405df55f80 | 0x43a8cab15D06d3a5fE5854D714C37E7E9246F170 | TBD                        |
| AVALANCHE | 0x340fe1d898eccaad394e2ba0fc1f93d27c7b717a | 0x3Ab1C9aDb065F3FcA0059652Cd7A52B05C98f9a9 | TBD                        |
| FTM    | 0x3e01b7e242d5af8064cb9a8f9468ac0f8683617c | 0x43a8cab15D06d3a5fE5854D714C37E7E9246F170 | TBD                        |

## Migration process
1. User approves the desired amount on the old token contract to the migration contract
2. User executes `swap()` on the migration contract
3. Migration contract locks the old token and sends the same exact amount of the new token

## UI
To make the process easier, there is a UI to handle the process for you
Go to (TBD.com), or alternatively fork (TBD) and run the migration

## More info
See [blogpost](https://www.orbs.com/OIP-6-Relief-for-Multichain-bridged-ORBS-Token-Holders/)