// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import '@fusionx/v3-core/contracts/interfaces/callback/IFusionXV3SwapCallback.sol';
import '@fusionx/v3-core/contracts/libraries/SafeCast.sol';
import '@fusionx/v3-core/contracts/interfaces/IFusionXV3Pool.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract TestFusionXswapCallee is IFusionXV3SwapCallback {
    using SafeCast for uint256;

    function swapExact0For1(
        address pool,
        uint256 amount0In,
        address recipient,
        uint160 sqrtPriceLimitX96
    ) external {
        IFusionXV3Pool(pool).swap(recipient, true, amount0In.toInt256(), sqrtPriceLimitX96, abi.encode(msg.sender));
    }

    function swap0ForExact1(
        address pool,
        uint256 amount1Out,
        address recipient,
        uint160 sqrtPriceLimitX96
    ) external {
        IFusionXV3Pool(pool).swap(recipient, true, -amount1Out.toInt256(), sqrtPriceLimitX96, abi.encode(msg.sender));
    }

    function swapExact1For0(
        address pool,
        uint256 amount1In,
        address recipient,
        uint160 sqrtPriceLimitX96
    ) external {
        IFusionXV3Pool(pool).swap(recipient, false, amount1In.toInt256(), sqrtPriceLimitX96, abi.encode(msg.sender));
    }

    function swap1ForExact0(
        address pool,
        uint256 amount0Out,
        address recipient,
        uint160 sqrtPriceLimitX96
    ) external {
        IFusionXV3Pool(pool).swap(recipient, false, -amount0Out.toInt256(), sqrtPriceLimitX96, abi.encode(msg.sender));
    }

    function fusionXV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external override {
        address sender = abi.decode(data, (address));

        if (amount0Delta > 0) {
            IERC20(IFusionXV3Pool(msg.sender).token0()).transferFrom(sender, msg.sender, uint256(amount0Delta));
        } else {
            assert(amount1Delta > 0);
            IERC20(IFusionXV3Pool(msg.sender).token1()).transferFrom(sender, msg.sender, uint256(amount1Delta));
        }
    }
}
