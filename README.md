# ExCcxt 🚀

_Because who has time to write JavaScript when you could be writing Elixir?_

This is a lovingly maintained fork of the sadly abandoned [ccxtex](https://github.com/metachaos-systems/ccxtex). We've dusted it off, given it some TLC, and made it work with the modern world of crypto trading.

ExCcxt is your friendly Elixir bridge to the amazing [CCXT library](https://github.com/ccxt/ccxt) - the Swiss Army knife of cryptocurrency exchange APIs. Think of it as a translator that speaks both Elixir and JavaScript, so you don't have to suffer through `npm install` nightmares.

With ExCcxt, you can query market data, fetch tickers, and do all sorts of crypto wizardry across 130+ exchanges including Binance, Coinbase, Kraken, and that one exchange your friend keeps telling you about.

## Supported Exchanges 🌐

ExCcxt supports **130+ cryptocurrency exchanges** through the CCXT library. Here's the complete list:

| Exchange | Exchange | Exchange | Exchange | Exchange |
|----------|----------|----------|----------|----------|
| aax | alpaca | ascendex | bequant | bibox |
| bigone | binance | binancecoinm | binanceus | binanceusdm |
| bit2c | bitbank | bitbay | bitbns | bitcoincom |
| bitfinex | bitfinex2 | bitflyer | bitforex | bitget |
| bithumb | bitmart | bitmex | bitopro | bitpanda |
| bitrue | bitso | bitstamp | bitstamp1 | bittrex |
| bitvavo | bkex | bl3p | blockchaincom | btcalpha |
| btcbox | btcex | btcmarkets | btctradeua | btcturk |
| buda | bw | bybit | bytetrade | cex |
| coinbase | coinbaseprime | coinbasepro | coincheck | coinex |
| coinfalcon | coinmate | coinone | coinspot | crex24 |
| cryptocom | currencycom | delta | deribit | digifinex |
| eqonex | exmo | flowbtc | fmfwio | ftx |
| ftxus | gate | gateio | gemini | hitbtc |
| hitbtc3 | hollaex | huobi | huobijp | huobipro |
| idex | independentreserve | indodax | itbit | kraken |
| kucoin | kucoinfutures | kuna | latoken | lbank |
| lbank2 | liquid | luno | lykke | mercado |
| mexc | mexc3 | ndax | novadax | oceanex |
| okcoin | okex | okex5 | okx | paymium |
| phemex | poloniex | probit | qtrade | ripio |
| stex | therock | tidebit | tidex | timex |
| tokocrypto | upbit | wavesexchange | wazirx | whitebit |
| woo | yobit | zaif | zb | zipmex |
| zonda | | | | |

_All exchanges support public APIs. Private API support depends on the exchange's authentication requirements._

## Installation 📦

### Step 1: Add to your mix.exs

```elixir
def deps do
  [
    {:ex_ccxt, "~> 0.1.0"}
  ]
end
```

### Step 2: Make sure you have Node.js

You'll need Node.js (>= 14) installed because, well, CCXT is written in JavaScript and we haven't figured out how to rewrite 100+ exchange APIs in pure Elixir yet. 😅

```bash
# Check if you have Node.js
node --version

# If not, install it (macOS with Homebrew)
brew install node

# Or use your favorite package manager
```

### Step 3: Profit! 💰

```bash
mix deps.get
```

## How To Call Public API

For Public API function, just call right away.

### Get a list of all supported exchanges

```elixir
iex> ExCcxt.exchanges()
{:ok, ["aax", "alpaca", "ascendex", "bequant", "bibox", "bigone", "binance", ...]} # 130+ exchanges!
```

### Fetch a ticker (current price info)

```elixir
iex> ExCcxt.fetch_ticker("binance", "BTC", "USDT")
{:ok,
 %ExCcxt.Ticker{
   symbol: "BTC/USDT",
   last: 43250.50,
   bid: 43245.10,
   ask: 43255.90,
   high: 44100.00,
   low: 42800.75,
   # ... lots more juicy data
 }}
```

### Get all tickers from an exchange

```elixir
iex> ExCcxt.fetch_tickers("binance")
{:ok, %{
  "BTC/USDT" => %ExCcxt.Ticker{...},
  "ETH/USDT" => %ExCcxt.Ticker{...},
  # ... hundreds of trading pairs
}}
```

### Fetch historical OHLCV data (candlesticks)

```elixir
iex> opts = %ExCcxt.OhlcvOpts{
...>   exchange: "binance",
...>   base: "BTC",
...>   quote: "USDT",
...>   timeframe: "1h",
...>   since: ~N[2023-01-01 00:00:00],
...>   limit: 100
...> }
iex> ExCcxt.fetch_ohlcvs(opts)
{:ok, [%ExCcxt.OHLCV{...}, ...]} # Sweet, sweet candlestick data
```

### Get order book (live buy/sell orders)

```elixir
iex> ExCcxt.fetch_order_book("kraken", "BTC/USD")
{:ok,
 %ExCcxt.OrderBook{
   bids: [[43240.5, 1.2], [43235.0, 0.8], ...], # [price, amount]
   asks: [[43250.1, 0.5], [43255.2, 1.1], ...],
   symbol: "BTC/USD"
 }}
```

### List all available markets

```elixir
iex> ExCcxt.fetch_markets("coinbase")
{:ok, [
  %ExCcxt.Market{
    symbol: "BTC/USD",
    base: "BTC",
    quote: "USD",
    active: true,
    type: "spot"
  }, ...
]}
```

## How to Call Private API.

Authentication :

To call Private API, depends on your Exchange, it might require differen type of authentication. The most common one is API Key and API Secret. To check what type of authentication your exchange requires, you can use `ExCcxt.required_credentials/1`.

Example:

```elixir
iex> ExCcxt.required_credentials("binance")
```

This will return

```elixir
{:ok,
 %{
   "apiKey" => true,
   "login" => false,
   "password" => false,
   "privateKey" => false,
   "secret" => true,
   "token" => false,
   "twofa" => false,
   "uid" => false,
   "walletAddress" => false
 }}
```

This means you need to provide `apiKey` and `secret` to call private API.

From here after obtain your API Key and API Secret, you can create credential data:

```elixir
{:ok, credential} = ExCcxt.Credential.new(name: "binance", apiKey: "your-api-key", secret: "your-api-secret")

{:ok,
 %ExCcxt.Credential{
   walletAddress: nil,
   uid: nil,
   twofa: nil,
   token: nil,
   secret: "your-api-secret",
   privateKey: nil,
   password: nil,
   login: nil,
   apiKey: "your-api-key",
   name: "binance"
 }}

```

From here, everytime you need to call private API, you can pass the credential data to the function.

Example:

```elixir
ExCcxt.fetch_balance(credential)
```

That's it!

Other Private API Examples:

```elixir
# Fetch account balance
ExCcxt.fetch_balance(credential)

# Fetch open orders
ExCcxt.fetch_open_orders(credential)

# Create a limit buy order
ExCcxt.create_order(credential, "BTC/USDT", "limit", "buy", 0.001, 43250.0)

# Cancel an order
ExCcxt.cancel_order(credential, "order_id", "BTC/USDT")

# Fetch your trading history
ExCcxt.fetch_my_trades(credential)

# Fetch all orders (open, closed, canceled)
ExCcxt.fetch_orders(credential)

# Create market orders
ExCcxt.create_market_buy_order(credential, "BTC/USDT", 0.001)
ExCcxt.create_market_sell_order(credential, "BTC/USDT", 0.001)
```

## What Works Right Now ✅

We've implemented the full CCXT unified API! Here's what you can do:

### Public APIs (No authentication needed)

- 🎯 **Market Data**: `fetch_ticker`, `fetch_tickers`, `fetch_markets`, `fetch_currencies`
- 📊 **Price History**: `fetch_ohlcvs` (OHLCV candlestick data)
- 📈 **Trading Data**: `fetch_trades`, `fetch_order_book`, `fetch_l2_order_book`
- 🔍 **Exchange Info**: `exchanges()`, `fetch_status`, `load_markets`
- 📉 **Derivatives**: `fetch_open_interest`, `fetch_funding_rates`, `fetch_greeks`
- 🏦 **Options**: `fetch_option`, `fetch_option_chain`
- 💱 **Convert**: `fetch_convert_quote`

### Private APIs (Authentication required) 🔐

- 💰 **Account**: `fetch_balance`
- 🛒 **Orders**: `create_order`, `cancel_order`, `fetch_orders`, `fetch_open_orders`, `fetch_closed_orders`, `fetch_canceled_orders`
- 📋 **Order Types**: `create_limit_buy_order`, `create_limit_sell_order`, `create_market_buy_order`, `create_market_sell_order`
- 💸 **Trading History**: `fetch_my_trades`, `fetch_my_liquidations`
- 🏛️ **Lending**: `fetch_cross_borrow_rate`, `fetch_cross_borrow_rates`, `fetch_isolated_borrow_rate`, `fetch_isolated_borrow_rates`
- 💱 **Convert Trading**: `create_convert_trade`

**✅ Authentication Supported**: All private APIs now support full authentication using the `ExCcxt.Credential` struct. Just pass your API credentials and start trading! 🚀

## Current Status 🚀

This library is now **production-ready** for most trading use cases! Here's where we stand:

### ✅ What's Solid

- **All unified API functions implemented** (40+ functions!)
- **Full authentication support** for private APIs 🔐
- **Complete market data access** (public APIs)
- **Full trading functionality** (create, cancel, manage orders)
- **Proper Elixir structs** with type safety
- **Account management** (balance, trading history)
- **Advanced trading features** (lending rates, liquidations, convert trading)

### 🚧 What's Coming

- Better error handling and retries
- WebSocket support for real-time data
- More examples and tutorials
- Performance optimizations
- Comprehensive documentation

### 💡 What's Not Here (Yet)

- Real-time streaming (WebSockets)
- Portfolio management helpers
- Advanced order types beyond CCXT unified API

## Contributing 🤝

Found a bug? Want to add a feature? PRs welcome! This library is a work in progress and we're always looking for help. Or do you think we should totally implement the full CCXT in Elixir instead of wrapping the JavaScript library?

## Disclaimer ⚠️

This library can help you lose money very efficiently. Trade responsibly, test thoroughly, and remember: past performance does not guarantee future results. We are not responsible for your trading decisions or any losses incurred.

_May your profits be high and your gas fees be low!_ 📈
