// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../src/Dex.sol";

// You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.
// You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

contract EchidnaTest {
    address echidna = msg.sender;

    SwappableToken tokenA;
    SwappableToken tokenB;
    Dex dexContract;

    address tokenAAddress;
    address tokenBAddress;
    address dexAddress;

    struct State {
        address from;
        address to;
        uint256 amount;
    }

    State[] states;

    constructor() {
        dexContract = new Dex();
        dexAddress = address(dexContract);

        tokenA = new SwappableToken(dexAddress, "TokenA", "A", 110);
        tokenB = new SwappableToken(dexAddress, "TokenB", "B", 110);

        tokenA.transfer(address(this), 10);
        tokenB.transfer(address(this), 10);

        tokenAAddress = address(tokenA);
        tokenBAddress = address(tokenB);

        dexContract.setTokens(tokenAAddress, tokenBAddress);
        dexContract.approve(dexAddress, 100);

        dexContract.addLiquidity(tokenAAddress, 100);
        dexContract.addLiquidity(tokenBAddress, 100);

        dexContract.renounceOwnership();
    }

    event Log(address to, address from, uint256 amount);

    function swap(address from, address to, uint256 amount, uint256 approveAmount) public {
        // pre-conditions
        // only two addresses are valid, and amount should be <= balance
        if (from < to) {
            from = tokenAAddress;
            to = tokenBAddress;
            amount = amount % tokenA.balanceOf(address(this)) + 1;
        } else {
            to = tokenAAddress;
            from = tokenBAddress;
            amount = amount % tokenB.balanceOf(address(this)) + 1;
        }
        if (approveAmount < amount) {
            // if approve amount less than amount, swap them
            uint256 temp;
            temp = approveAmount;
            approveAmount = amount;
            amount = temp;
        }

        // record state snapshots for echidna
        State memory state = State(from, to, amount);
        states.push(state);
        for (uint256 i = 0; i < states.length; i++) {
            emit Log(states[i].from, states[i].to, states[i].amount);
        }

        // action
        dexContract.approve(dexAddress, approveAmount);
        dexContract.swap(from, to, amount);

        // post-condition
        assert(tokenA.balanceOf(address(this)) < 100 && tokenB.balanceOf(address(this)) < 100);
    }
}
