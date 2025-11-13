# ExCcxt

This is a fork of https://github.com/metachaos-systems/ccxtex which is unmaintained for quite a while.

ExCcxt package provides easy Elixirinteroperability with JS version of [ccxt library](https://github.com/ccxt/ccxt). Ccxt provides an unified API for querying for historical/recent data and trading operations for multiple cryptocurrency exchanges including GDAX, Bitfinex, Poloniex, Binance and others.

## Installation

### Elixir

```elixir
def deps do
  [
    {:ex_ccxt, "~> 0.0.1"}
  ]
end
```

### JS

You need nodejs (>= 10) installed to run ExCcxt.

## Status and roadmap

ExCcxt is usable, but is under active development. Some exchanges do not support all methods/require CORS/have other esoteric requirements. Please consult [ccxt documentation](https://github.com/ccxt/ccxt) for more details.

### Public APIs in progress

- [x] fetch_ticker
- [x] fetch_tickers
- [x] fetch_ohlcv
- [x] fetch_exchanges
- [x] fetch_markets
- [ ] fetch_trades
- [ ] fetch_order_book
- [ ] fetch_l2_order_book

### Developer experience improvements

- [x] unified public API call option structs
- [x] investigate alternative parallelism/concurrency implementation
- [ ] improve general usability of library

### Private APIs implementation and authentication are under consideration
