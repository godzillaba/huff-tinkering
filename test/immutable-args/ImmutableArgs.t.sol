// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

interface IImmutableArgs {
    function arg1() external view returns (uint256);
}

contract ImmutableArgsTest is Test {
    uint256 arg1 = 113;
    uint256 arg2 = 42;

    IImmutableArgs immutableArgs;
    function setUp() public {
        bytes memory args = abi.encode(arg2, arg1);
        immutableArgs = IImmutableArgs(HuffDeployer.deploy_with_args("immutable-args/ImmutableArgs", args));
    }

    function testFoo() public {
        assertEq(immutableArgs.arg1(), arg1);
    }
}