// ᗪᗩGOᑎ 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

import {Ragequitter} from "../src/Ragequitter.sol";

import "@forge/Test.sol";

contract RagequitterTest is Test {
    function setUp() public {}

    function testDeploy() public {
        new Ragequitter();
    }
}
