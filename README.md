# Capture the Ether

[ethernauts source](https://ethernaut.openzeppelin.com/level/22)

> The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

> You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

> You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

## commands

Run Echidna which finds the attack with the command below. This will run the assertion tests in EchidnaTest.sol.

```zsh
echidna . --config config.yaml --contract EchidnaTest --test-limit 10000
```

Run the forge test which implements the attack with the command below.

```zsh
forge test -vvv
```
