// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import '../libraries/TickMath.sol';

import '../interfaces/callback/IFusionXV3SwapCallback.sol';

import '../interfaces/IFusionXV3Pool.sol';

contract TestFusionXV3ReentrantCallee is IFusionXV3SwapCallback {
    string private constant expectedReason = 'LOK';

    function swapToReenter(address pool) external {
        IFusionXV3Pool(pool).swap(address(0), false, 1, TickMath.MAX_SQRT_RATIO - 1, new bytes(0));
    }

    function fusionXV3SwapCallback(
        int256,
        int256,
        bytes calldata
    ) external override {
        // try to reenter swap
        try IFusionXV3Pool(msg.sender).swap(address(0), false, 1, 0, new bytes(0)) {} catch Error(
            string memory reason
        ) {
            require(keccak256(abi.encode(reason)) == keccak256(abi.encode(expectedReason)));
        }

        // try to reenter mint
        try IFusionXV3Pool(msg.sender).mint(address(0), 0, 0, 0, new bytes(0)) {} catch Error(string memory reason) {
            require(keccak256(abi.encode(reason)) == keccak256(abi.encode(expectedReason)));
        }

        // try to reenter collect
        try IFusionXV3Pool(msg.sender).collect(address(0), 0, 0, 0, 0) {} catch Error(string memory reason) {
            require(keccak256(abi.encode(reason)) == keccak256(abi.encode(expectedReason)));
        }

        // try to reenter burn
        try IFusionXV3Pool(msg.sender).burn(0, 0, 0) {} catch Error(string memory reason) {
            require(keccak256(abi.encode(reason)) == keccak256(abi.encode(expectedReason)));
        }

        // try to reenter flash
        try IFusionXV3Pool(msg.sender).flash(address(0), 0, 0, new bytes(0)) {} catch Error(string memory reason) {
            require(keccak256(abi.encode(reason)) == keccak256(abi.encode(expectedReason)));
        }

        // try to reenter collectProtocol
        try IFusionXV3Pool(msg.sender).collectProtocol(address(0), 0, 0) {} catch Error(string memory reason) {
            require(keccak256(abi.encode(reason)) == keccak256(abi.encode(expectedReason)));
        }

        require(false, 'Unable to reenter');
    }
}
