# Simple Swap Protocol

This is a basic token swap protocol implemented in Sui Move. It allows users to swap between two token types (TokenA and TokenB) using a liquidity pool.

## Functionality
- Initialize a liquidity pool with TokenA and TokenB.
- Add liquidity to the pool by depositing both tokens.
- Remove liquidity from the pool.
- Swap TokenA for TokenB or vice versa based on pool reserves.

## Files
- `swap.move`: The main Move module implementing the swap protocol.

## Usage
1. Initialize the pool using `init_pool`.
2. Add liquidity with `add_liquidity`.
3. Swap tokens using `swap_a_to_b` or `swap_b_to_a`.
4. Remove liquidity with `remove_liquidity`.
