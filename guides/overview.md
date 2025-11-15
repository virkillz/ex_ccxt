# Overview

ExCcxt is an Elixir library that provides a bridge to the popular [CCXT cryptocurrency trading library](https://github.com/ccxt/ccxt) written in JavaScript. It allows Elixir applications to access unified APIs for multiple cryptocurrency exchanges while leveraging the extensive functionality of the CCXT library.

## What is CCXT?

CCXT is a JavaScript/Python/PHP library for cryptocurrency trading and e-commerce with support for many bitcoin/ether/altcoin exchange markets and merchant APIs. It provides:

- A unified API for 100+ cryptocurrency exchanges
- Standardized data structures for tickers, trades, order books, and more
- Support for both public market data and private trading operations
- Active maintenance and regular updates

## Why ExCcxt?

ExCcxt brings the power of CCXT to the Elixir ecosystem by:

- **Bridging Languages**: Leveraging JavaScript's rich CCXT ecosystem while maintaining Elixir's strengths
- **Type Safety**: Converting raw JavaScript responses to typed Elixir structs
- **Process Isolation**: Running JavaScript in separate Node.js processes to prevent crashes
- **Concurrency**: Using a NodeJS process pool for parallel exchange API calls
- **Supervision**: Automatically restarting failed NodeJS processes
- **Unified Interface**: Providing a single Elixir API for 100+ cryptocurrency exchanges

## Architecture

ExCcxt uses a multi-layered architecture:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Elixir App    │───▶│    ExCcxt        │───▶│   Node.js       │
│                 │    │   (Bridge)       │    │   + CCXT        │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

1. **Elixir Layer**: Provides the main API and handles data transformation
2. **Bridge Layer**: Manages communication between Elixir and Node.js
3. **JavaScript Layer**: Wraps CCXT library calls
4. **CCXT Library**: Handles actual exchange communications

## Supported Exchanges

ExCcxt supports all exchanges available in the CCXT library, including:

- Binance
- Coinbase Pro
- Kraken
- Bitfinex
- Huobi
- KuCoin
- And 100+ more

## Key Features

### Public Market Data
- Real-time ticker information
- Historical OHLCV (candlestick) data
- Market information and trading pairs
- Exchange capabilities and limits

### Data Types
- Strongly typed Elixir structs
- Automatic conversion from JavaScript objects
- Consistent field naming (snake_case)

### Process Management
- Supervised NodeJS process pool
- Automatic process recovery
- Configurable pool size for concurrency

### Error Handling
- Graceful error propagation from JavaScript
- Detailed error messages
- Connection timeout handling

## Use Cases

ExCcxt is perfect for:

- **Trading Bots**: Build automated trading systems in Elixir
- **Market Analysis**: Collect and analyze market data across exchanges
- **Portfolio Tracking**: Monitor asset prices and portfolio performance
- **Arbitrage Detection**: Compare prices across multiple exchanges
- **Research Applications**: Academic and financial research projects

## Next Steps

- [Installation Guide](installation.md) - Get started with ExCcxt
- [Public API Reference](public_api.md) - Learn about available functions
- [Disclaimer](disclaimer.md) - Important usage considerations