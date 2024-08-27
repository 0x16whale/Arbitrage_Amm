//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0<0.8.20;

import "./IPool.sol";

interface ISyncRouter is IPool{
    // The Router contract has Multicall and SelfPermit enabled.

    struct TokenInput {
        address token;
        uint amount;
    }

    struct SwapStep {
        address pool; // The pool of the step.
        bytes data; // The data to execute swap with the pool.
        address callback;
        bytes callbackData;
    }

    struct SwapPath {
        SwapStep[] steps; // Steps of the path.
        address tokenIn; // The input token of the path.
        uint amountIn; // The input token amount of the path.
    }

    struct SplitPermitParams {
        address token;
        uint approveAmount;
        uint deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct ArrayPermitParams {
        uint approveAmount;
        uint deadline;
        bytes signature;
    }

    // Returns the vault address.
    function vault() external view returns (address);

    // Returns the wETH address.
    function wETH() external view returns (address);

    // Adds some liquidity (supports unbalanced mint).
    // Alternatively, use `addLiquidity2` with the same params to register the position,
    // to make sure it can be indexed by the interface.
    function addLiquidity(
        address pool,
        TokenInput[] calldata inputs,
        bytes calldata data,
        uint minLiquidity,
        address callback,
        bytes calldata callbackData
    ) external payable returns (uint liquidity);

    // Adds some liquidity with permit (supports unbalanced mint).
    // Alternatively, use `addLiquidityWithPermit` with the same params to register the position,
    // to make sure it can be indexed by the interface.
    function addLiquidityWithPermit(
        address pool,
        TokenInput[] calldata inputs,
        bytes calldata data,
        uint minLiquidity,
        address callback,
        bytes calldata callbackData,
        SplitPermitParams[] memory permits
    ) external payable returns (uint liquidity);

    // Burns some liquidity (balanced).
    function burnLiquidity(
        address pool,
        uint liquidity,
        bytes calldata data,
        uint[] calldata minAmounts,
        address callback,
        bytes calldata callbackData
    ) external returns (IPool.TokenAmount[] memory amounts);

    // Burns some liquidity with permit (balanced).
    function burnLiquidityWithPermit(
        address pool,
        uint liquidity,
        bytes calldata data,
        uint[] calldata minAmounts,
        address callback,
        bytes calldata callbackData,
        ArrayPermitParams memory permit
    ) external returns (IPool.TokenAmount[] memory amounts);

    // Burns some liquidity (single).
    function burnLiquiditySingle(
        address pool,
        uint liquidity,
        bytes memory data,
        uint minAmount,
        address callback,
        bytes memory callbackData
    ) external returns (uint amountOut);
        
    // Burns some liquidity with permit (single).
    function burnLiquiditySingleWithPermit(
        address pool,
        uint liquidity,
        bytes memory data,
        uint minAmount,
        address callback,
        bytes memory callbackData,
        ArrayPermitParams calldata permit
    ) external returns (uint amountOut);

    // Performs a swap.
    function swap(
        SwapPath[] memory paths,
        uint amountOutMin,
        uint deadline
    ) external payable returns (uint amountOut);

    function swapWithPermit(
        SwapPath[] memory paths,
        uint amountOutMin,
        uint deadline,
        SplitPermitParams calldata permit
    ) external payable returns (uint amountOut);

    /// @notice Wrapper function to allow pool deployment to be batched.
    function createPool(address factory, bytes calldata data) external payable returns (address);

}