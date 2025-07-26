module swap_protocol::swap {
    use sui::object::{Self, UID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    struct Pool has key, store {
        id: UID,
        token_a: Balance,
        token_b: Balance
    }

    struct LP has key, store {
        id: UID,
        pool: address,
        amount: u64
    }

    public fun init_pool(token_a: Coin, token_b: Coin, ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            token_a: coin::into_balance(token_a),
            token_b: coin::into_balance(token_b)
        };
        transfer::share_object(pool);
    }

    public fun add_liquidity(pool: &mut Pool, token_a: Coin, token_b: Coin, ctx: &mut TxContext): LP {
        let amount_a = coin::value(&token_a);
        let amount_b = coin::value(&token_b);
        balance::join(&mut pool.token_a, coin::into_balance(token_a));
        balance::join(&mut pool.token_b, coin::into_balance(token_b));
        LP {
            id: object::new(ctx),
            pool: object::id_address(pool),
            amount: amount_a + amount_b
        }
    }

    public fun remove_liquidity(pool: &mut Pool, lp: LP, ctx: &mut TxContext): (Coin, Coin) {
        let LP { id, pool: pool_addr, amount } = lp;
        assert!(pool_addr == object::id_address(pool), 0);
        object::delete(id);
        let amount_a = amount / 2;
        let amount_b = amount - amount_a;
        (
            coin::take(&mut pool.token_a, amount_a, ctx),
            coin::take(&mut pool.token_b, amount_b, ctx)
        )
    }

    public fun swap_a_to_b(pool: &mut Pool, token_a: Coin, ctx: &mut TxContext): Coin {
        let amount_in = coin::value(&token_a);
        let amount_out = (balance::value(&pool.token_b) * amount_in) / (balance::value(&pool.token_a) + amount_in);
        balance::join(&mut pool.token_a, coin::into_balance(token_a));
        coin::take(&mut pool.token_b, amount_out, ctx)
    }

    public fun swap_b_to_a(pool: &mut Pool, token_b: Coin, ctx: &mut TxContext): Coin {
        let amount_in = coin::value(&token_b);
        let amount_out = (balance::value(&pool.token_a) * amount_in) / (balance::value(&pool.token_b) + amount_in);
        balance::join(&mut pool.token_b, coin::into_balance(token_b));
        coin::take(&mut pool.token_a, amount_out, ctx)
    }
}
