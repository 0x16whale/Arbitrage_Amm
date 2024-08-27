// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPoolFactory {
    function master() external view returns (address);

    function getDeployData() external view returns (bytes memory);

    function createPool(bytes calldata data) external returns (address pool);
}

interface IBasePoolFactory is IPoolFactory {
    event PoolCreated(
        address indexed token0,
        address indexed token1,
        address pool
    );

    function getPool(address tokenA, address tokenB) external view returns (address pool);

    function getSwapFee(
        address pool,
        address sender,
        address tokenIn,
        address tokenOut,
        bytes calldata data
    ) external view returns (uint24 swapFee);
}