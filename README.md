# Assembly Secret Accounts

This toy contract implements coin mining and secret transfers.
A single transfer is stored in a separate channel which is only accessible by recipient and sender.
Additionally swap operation is implemented - a two transfer back and forth between two KAs to make use of contract events.

# Usage
## Requirements
Haskell Stack installed, Podman and `~/.symbiont` with SDK installed present on the system.

## Build container image
```
./runpodman buildimage
```
To start the assembly node inside the container:
```
./runpodman start
```

## Deploy
To deploy the contract from `workspace/secretaccounts/secretaccounts.sympl` run:
```
./runpodman deploy
```

## Test
There are two tests implemented:
1. Mine and transfer:
    ```
    ./runpodman t-validate-transfer
    ```
1. Mine and execute swap:
    ```
    ./runpodman t-validate-transfer
    ```

## Extra
To interact with the node and contract one can use the following commands:
* `start` - start container with Assembly node
* `stop` - stop & remove container
* `shell` - start interactive shell inside the container
* `dashboard` - start Assembly dashboard GUI
* `create-ka` - create new key alias
* `deploy` - deploy the contract

The following commands expect `KA` environment variable (with key alias) to run:
* `c-mine-coin` - mine a coin
* `c-get-all-transfers` - get all transfers for KA
* `c-get-balance` - get balance for KA
* `c-send` - transfer coin between KAs
