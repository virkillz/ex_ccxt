# CcxtEx: Elixir-JavaScript Bridge for CCXT Library

## Overview

CcxtEx is an Elixir library that provides a bridge to the popular [CCXT cryptocurrency trading library](https://github.com/ccxt/ccxt) written in JavaScript. It allows Elixir applications to access unified APIs for multiple cryptocurrency exchanges while leveraging the extensive functionality of the CCXT library.

## Architecture

### High-Level Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Elixir App    │───▶│    CcxtEx        │───▶│   Node.js       │
│                 │    │   (Bridge)       │    │   + CCXT        │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │                          │
                              │                          │
                       ┌──────▼──────┐            ┌──────▼──────┐
                       │   Elixir    │            │ JavaScript  │
                       │  Structs    │            │   Functions │
                       │             │            │             │
                       │ • Ticker    │            │ • ccxt lib  │
                       │ • OHLCV     │            │ • exchange  │
                       │ • Market    │            │   instances │
                       └─────────────┘            └─────────────┘
```

## Core Components

### 1. JavaScript Layer (`js/source/main.js`)

The JavaScript layer acts as a thin wrapper around the CCXT library:

```javascript
const ccxt = require("ccxt");

async function fetchTicker({ exchange, symbol }) {
  const _exchange = new ccxt[exchange]();
  return await _exchange.fetchTicker(symbol);
}

async function fetchOhlcvs({ exchange, base, quote, timeframe, since, limit }) {
  const symbol = `${base}/${quote}`;
  const _exchange = new ccxt[exchange]();
  return await _exchange.fetchOHLCV(symbol, timeframe, since, limit);
}
```

**Key Functions:**

- `exchanges()` - Lists all available exchanges
- `fetchTicker()` - Fetches ticker data for a specific symbol
- `fetchOhlcvs()` - Fetches OHLCV (candlestick) data
- `fetchMarkets()` - Fetches market information
- `fetchTickers()` - Fetches multiple tickers

### 2. Elixir Bridge Layer (`lib/ex_ccxt.ex`)

The Elixir layer provides the main API and handles communication with the JavaScript runtime:

```elixir
def call_js_main(jsfn, args) do
  NodeJS.call({"exec.js", jsfn}, args)
end

def fetch_ticker(exchange, base, quote) do
  opts = %{
    exchange: exchange,
    symbol: base <> "/" <> quote
  }

  with {:ok, ticker} <- call_js_main(:fetchTicker, [opts]) do
    ticker =
      ticker
      |> MapKeys.to_snake_case()
      |> MapKeys.to_atoms_unsafe!()
      |> (&struct!(Ticker, &1)).()

    {:ok, ticker}
  else
    err_tup -> err_tup
  end
end
```

### 3. Application Supervision (`lib/ex_ccxt/application.ex`)

The application starts a supervised NodeJS process pool:

```elixir
def start(_type, _args) do
  js_path = Application.app_dir(:ex_ccxt, "priv/js/dist")

  children = [
    supervisor(NodeJS, [[path: js_path, pool_size: 16]])
  ]

  opts = [strategy: :one_for_one, name: ExCcxt.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Communication Flow

### 1. Function Call Flow

```
Elixir Function Call
        ↓
Data Preparation & Validation
        ↓
NodeJS.call({"exec.js", function_name}, args)
        ↓
JavaScript Function Execution
        ↓
CCXT Library API Call
        ↓
Exchange HTTP Request
        ↓
Response Processing
        ↓
Return to Elixir
        ↓
Data Transformation (snake_case, structs)
        ↓
Return Typed Elixir Struct
```

### 2. Example: Fetching a Ticker

1. **Elixir Call**: `ExCcxt.fetch_ticker("binance", "BTC", "USDT")`

2. **Data Preparation**:

   ```elixir
   opts = %{exchange: "binance", symbol: "BTC/USDT"}
   ```

3. **NodeJS Bridge**:

   ```elixir
   NodeJS.call({"exec.js", :fetchTicker}, [opts])
   ```

4. **JavaScript Execution**:

   ```javascript
   const _exchange = new ccxt["binance"]();
   return await _exchange.fetchTicker("BTC/USDT");
   ```

5. **Response Processing**:
   ```elixir
   # Convert to snake_case and create struct
   ticker
   |> MapKeys.to_snake_case()
   |> MapKeys.to_atoms_unsafe!()
   |> (&struct!(Ticker, &1)).()
   ```

## Data Types

### Ticker Struct

```elixir
%ExCcxt.Ticker{
  ask: 577.35,
  bid: 576.8,
  close: 577.35,
  high: 619.95,
  low: 549.28,
  base_volume: 73309.52075575,
  quote_volume: 42729187.26769644,
  timestamp: 1527170769000,
  # ... other fields
}
```

### OHLCV Struct

```elixir
%ExCcxt.OHLCV{
  base: "ETH",
  quote: "USDT",
  exchange: "bitfinex2",
  open: 736.77,
  high: 737.07,
  low: 726,
  close: 731.16,
  base_volume: 4234.62695691,
  timestamp: ~N[2018-01-01 00:00:00.000]
}
```

### Market Struct

```elixir
%ExCcxt.Market{
  active: true,
  base: "ETH",
  quote: "EUR",
  symbol: "ETH/EUR",
  precision: %{"amount" => 8, "price" => 2},
  limits: %{
    "amount" => %{"min" => 1.0e-8},
    "cost" => %{"min" => 5},
    "price" => %{"min" => 0.01}
  }
}
```

## Key Dependencies

### Elixir Dependencies (`mix.exs`)

- **`{:nodejs, "~> 1.0"}`** - Provides NodeJS runtime integration
- **`{:jason, "~> 1.1"}`** - JSON encoding/decoding
- **`{:typed_struct, "~> 0.1"}`** - Typed struct definitions
- **`{:map_keys, "~> 0.1"}`** - Key transformation utilities

### JavaScript Dependencies (`js/source/package.json`)

- **`"ccxt": "^1.18.420"`** - The core CCXT library

## Build Process

The JavaScript code is bundled using Webpack via `build_ex_ccxt_js.sh`:

```bash
webpack-cli ./js/source/main.js -o ./priv/js/dist/main.js \
  --output-library ex_ccxt \
  --output-library-target commonjs \
  --target node
```

This creates a bundled JavaScript file in `priv/js/dist/` that includes all CCXT dependencies.

## Advantages of This Architecture

1. **Language Separation**: Leverages JavaScript's rich CCXT ecosystem while maintaining Elixir's strengths
2. **Type Safety**: Raw JavaScript responses are converted to typed Elixir structs
3. **Process Isolation**: JavaScript runs in separate Node.js processes, preventing crashes from affecting the main Elixir application
4. **Concurrency**: NodeJS process pool (16 workers) allows parallel exchange API calls
5. **Supervision**: Failed NodeJS processes are automatically restarted by the Elixir supervisor
6. **Unified API**: Single Elixir interface for 100+ cryptocurrency exchanges

## Supported Operations

- **Public Data**: Tickers, OHLCV data, markets, exchanges list
- **Exchange Information**: Capabilities, trading pairs, limits
- **Real-time Data**: Current prices, order book snapshots (planned)
- **Historical Data**: OHLCV candlesticks with customizable timeframes

The library focuses on public market data APIs, with private trading APIs under consideration for future development.
