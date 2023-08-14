// SPDX-License-Identifier: GPL-2.0-or-later
import '@fusionx/v3-core/contracts/interfaces/IFusionXV3Pool.sol';

pragma solidity >=0.6.0;

import '../libraries/PoolTicksCounter.sol';

contract PoolTicksCounterTest {
    using PoolTicksCounter for IFusionXV3Pool;

    function countInitializedTicksCrossed(
        IFusionXV3Pool pool,
        int24 tickBefore,
        int24 tickAfter
    ) external view returns (uint32 initializedTicksCrossed) {
        return pool.countInitializedTicksCrossed(tickBefore, tickAfter);
    }
}
