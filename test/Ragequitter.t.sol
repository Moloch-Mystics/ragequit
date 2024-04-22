// ᗪᗩGOᑎ 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import "@forge/Test.sol";

import {Ragequitter} from "../src/Ragequitter.sol";

import {MockERC20} from "@solady/test/utils/mocks/MockERC20.sol";

contract RagequitterTest is Test {
    Ragequitter internal ragequitter;
    MockERC20 internal asset0;

    function setUp() public {
        ragequitter = new Ragequitter();
        asset0 = new MockERC20("Test", "Test", 18);
        asset0.mint(address(this), 100);
    }

    function testDeploy() public {
        new Ragequitter();
    }

    function testInstall() public {
        ragequitter.install(0, type(uint48).max);
    }

    function testMint() public {
        ragequitter.mint(address(this), 50);
        ragequitter.mint(address(1), 50);
    }

    function testRagequit() public {
        testInstall();
        testMint();
        asset0.approve(address(ragequitter), type(uint256).max);
        address[] memory assets = new address[](1);
        assets[0] = address(asset0);
        assertEq(ragequitter.balanceOf(address(this), uint256(uint160(address(this)))), 50);
        assertEq(ragequitter.balanceOf(address(1), uint256(uint160(address(this)))), 50);
        assertEq(asset0.balanceOf(address(this)), 100);
        assertEq(asset0.balanceOf(address(1)), 0);
        vm.prank(address(1));
        ragequitter.ragequit(address(this), 50, assets);
        assertEq(ragequitter.balanceOf(address(this), uint256(uint160(address(this)))), 50);
        assertEq(ragequitter.balanceOf(address(1), uint256(uint160(address(this)))), 0);
        assertEq(asset0.balanceOf(address(this)), 50);
        assertEq(asset0.balanceOf(address(1)), 50);
    }
}
