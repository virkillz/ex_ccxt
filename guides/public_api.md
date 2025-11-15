# Public API Reference

The Public API provides access to market data and exchange information without requiring authentication. These functions can be used to retrieve real-time and historical market data from cryptocurrency exchanges.

## Core Functions

### exchanges/0

Returns a list of all supported exchanges.

```elixir
ExCcxt.exchanges()
```

**Returns:**
```elixir
{:ok, ["aax", "alpaca", "coincheck", "coinex", "okex5", "okx", "paymium", ...]}
```

---

### fetch_ticker/3

Fetches current ticker information for a trading pair.

```elixir
ExCcxt.fetch_ticker(exchange, base, quote)
```

**Parameters:**
- `exchange` (String) - Exchange name (e.g., "binance", "coinbase")
- `base` (String) - Base currency (e.g., "BTC", "ETH")
- `quote` (String) - Quote currency (e.g., "USDT", "USD")

**Returns:**
```elixir
{:ok, %ExCcxt.Ticker{
  symbol: "BTC/USDT",
  last: 102906.15,
  bid: 102869,
  ask: 102916.64,
  high: 105331.15,
  low: 100842.93,
  open: 104855.62,
  close: 102906.15,
  base_volume: 938.25807,
  quote_volume: 96485861.8715014,
  percentage: -1.8591945763136015,
  change: -1949.47,
  timestamp: 1763033564893,
  datetime: "2025-11-13T11:32:44.893Z",
  # ... additional fields
}}
```

**Example:**
```elixir
{:ok, ticker} = ExCcxt.fetch_ticker("binance", "BTC", "USDT")
IO.puts("Current BTC price: $#{ticker.last}")
```

---

### fetch_tickers/1

Fetches all available tickers from an exchange.

```elixir
ExCcxt.fetch_tickers(exchange)
```

**Parameters:**
- `exchange` (String) - Exchange name

**Returns:**
```elixir
{:ok, %{
  "BTC/USDT" => %ExCcxt.Ticker{...},
  "ETH/USDT" => %ExCcxt.Ticker{...},
  # ... more tickers
}}
```

**Example:**
```elixir
{:ok, tickers} = ExCcxt.fetch_tickers("binance")
btc_ticker = tickers["BTC/USDT"]
```

---

### fetch_ohlcvs/1

Fetches OHLCV (candlestick) data for technical analysis.

```elixir
ExCcxt.fetch_ohlcvs(%ExCcxt.OhlcvOpts{
  exchange: "binance",
  base: "BTC",
  quote: "USDT",
  timeframe: "1h",
  since: ~N[2024-01-01 00:00:00],
  limit: 100
})
```

**Parameters:**
- `exchange` (String) - Exchange name
- `base` (String) - Base currency
- `quote` (String) - Quote currency
- `timeframe` (String) - Candlestick interval ("1m", "5m", "15m", "1h", "4h", "1d")
- `since` (NaiveDateTime, optional) - Start time for historical data
- `limit` (Integer, optional) - Maximum number of candlesticks to return

**Returns:**
```elixir
{:ok, [
  %ExCcxt.OHLCV{
    base: "BTC",
    quote: "USDT",
    exchange: "binance",
    open: 45000.0,
    high: 45500.0,
    low: 44800.0,
    close: 45200.0,
    base_volume: 123.45,
    timestamp: ~N[2024-01-01 00:00:00.000]
  },
  # ... more candlesticks
]}
```

---

### fetch_order_book/2

Fetches the current order book for a trading pair.

```elixir
ExCcxt.fetch_order_book(exchange, symbol)
```

**Parameters:**
- `exchange` (String) - Exchange name
- `symbol` (String) - Trading pair symbol (e.g., "BTC/USDT")

**Returns:**
```elixir
{:ok, %ExCcxt.OrderBook{
  symbol: "BTC/USDT",
  bids: [[102869.00, 1.0234], [102865.12, 0.5678], ...],
  asks: [[102916.64, 0.2603], [102920.3, 0.19285], ...],
  timestamp: 1763033564893,
  datetime: "2025-11-13T11:32:44.893Z"
}}
```

---

### fetch_l2_order_book/4

Fetches a price-aggregated (L2) order book.

```elixir
ExCcxt.fetch_l2_order_book(exchange, symbol, limit \\ nil, params \\ %{})
```

**Parameters:**
- `exchange` (String) - Exchange name
- `symbol` (String) - Trading pair symbol
- `limit` (Integer, optional) - Maximum number of price levels
- `params` (Map, optional) - Additional parameters

---

### fetch_markets/1

Fetches all available trading pairs and their information.

```elixir
ExCcxt.fetch_markets(exchange)
```

**Returns:**
```elixir
{:ok, [
  %ExCcxt.Market{
    active: true,
    base: "BTC",
    quote: "USDT",
    symbol: "BTC/USDT",
    type: "spot",
    spot: true,
    margin: false,
    maker: 0.001,
    taker: 0.001,
    precision: %{"amount" => 8, "price" => 2},
    limits: %{
      "amount" => %{"min" => 1.0e-8},
      "cost" => %{"min" => 10},
      "price" => %{"min" => 0.01}
    }
  },
  # ... more markets
]}
```

---

### load_markets/2

Loads and caches market information for faster subsequent access.

```elixir
ExCcxt.load_markets(exchange, reload \\ false)
```

**Parameters:**
- `exchange` (String) - Exchange name
- `reload` (Boolean) - Force reload cached data

---

### fetch_currencies/1

Fetches information about all supported currencies on an exchange.

```elixir
ExCcxt.fetch_currencies(exchange)
```

**Returns:**
```elixir
{:ok, %{
  "BTC" => %ExCcxt.Currency{
    active: true,
    code: "BTC",
    name: "Bitcoin",
    type: "crypto",
    precision: 1.0e-8,
    deposit: true,
    withdraw: true,
    fee: 0.0005,
    limits: %{"amount" => %{}, "withdraw" => %{}}
  },
  # ... more currencies
}}
```

---

### fetch_status/2

Fetches the operational status of an exchange.

```elixir
ExCcxt.fetch_status(exchange, params \\ %{})
```

**Returns:**
```elixir
{:ok, %{"status" => "ok", "updated" => 1763037264132}}
```

---

### required_credentials/1

Returns the authentication credentials required for private API access.

```elixir
ExCcxt.required_credentials(exchange)
```

**Returns:**
```elixir
{:ok, %{
  "apiKey" => true,
  "secret" => true,
  "password" => false,
  "uid" => false,
  # ... other credential requirements
}}
```

## Advanced Market Data

### fetch_trades/4

Fetches recent public trade history for a symbol.

```elixir
ExCcxt.fetch_trades(exchange, base, quote, since \\ nil)
```

---

### fetch_funding_rate/3

Fetches the current funding rate for perpetual contracts.

```elixir
ExCcxt.fetch_funding_rate(exchange, symbol, params \\ %{})
```

---

### fetch_funding_rates/3

Fetches funding rates for multiple symbols.

```elixir
ExCcxt.fetch_funding_rates(exchange, symbols \\ nil, params \\ %{})
```

---

### fetch_funding_rate_history/5

Fetches historical funding rates.

```elixir
ExCcxt.fetch_funding_rate_history(exchange, symbol, since \\ nil, limit \\ nil, params \\ %{})
```

---

### fetch_open_interest/3

Fetches open interest data for futures contracts.

```elixir
ExCcxt.fetch_open_interest(exchange, symbol, params \\ %{})
```

## Options Trading

### fetch_option/3

Fetches option contract information.

```elixir
ExCcxt.fetch_option(exchange, symbol, params \\ %{})
```

---

### fetch_option_chain/3

Fetches all options for an underlying asset.

```elixir
ExCcxt.fetch_option_chain(exchange, code, params \\ %{})
```

---

### fetch_greeks/3

Fetches option Greeks (delta, gamma, theta, vega).

```elixir
ExCcxt.fetch_greeks(exchange, symbol, params \\ %{})
```

## Error Handling

All public API functions return either `{:ok, result}` or `{:error, reason}` tuples. Common error scenarios include:

- **Network timeouts**: Exchange API is unreachable
- **Invalid symbols**: Trading pair doesn't exist on the exchange
- **Rate limiting**: Too many requests sent to the exchange
- **Exchange errors**: Internal exchange API errors

**Example error handling:**
```elixir
case ExCcxt.fetch_ticker("binance", "INVALID", "SYMBOL") do
  {:ok, ticker} -> 
    IO.puts("Price: #{ticker.last}")
  {:error, reason} -> 
    IO.puts("Error: #{reason}")
end
```

## Rate Limiting

Different exchanges have different rate limits. Consider implementing delays between requests or using connection pooling for high-frequency applications:

```elixir
# Simple rate limiting example
Enum.each(symbols, fn symbol ->
  {:ok, ticker} = ExCcxt.fetch_ticker("binance", symbol, "USDT")
  Process.sleep(100) # 100ms delay between requests
end)
```

## Data Structure Details

### Ticker Fields

- `symbol` - Trading pair symbol
- `last` - Last trade price
- `bid` - Highest bid price
- `ask` - Lowest ask price
- `high` - 24h high price
- `low` - 24h low price
- `open` - 24h opening price
- `close` - 24h closing price
- `base_volume` - 24h base currency volume
- `quote_volume` - 24h quote currency volume
- `percentage` - 24h price change percentage
- `change` - 24h absolute price change
- `timestamp` - Unix timestamp in milliseconds
- `datetime` - ISO8601 datetime string

### OHLCV Fields

- `open` - Opening price
- `high` - Highest price
- `low` - Lowest price
- `close` - Closing price
- `base_volume` - Volume in base currency
- `timestamp` - Period start time

### OrderBook Fields

- `bids` - List of [price, amount] bid orders
- `asks` - List of [price, amount] ask orders
- `timestamp` - Order book timestamp
- `symbol` - Trading pair symbol

## Next Steps

- [Private API Reference](private_api.md) - Learn about authenticated trading functions
- [Installation Guide](installation.md) - Setup instructions
- [Disclaimer](disclaimer.md) - Important usage considerations