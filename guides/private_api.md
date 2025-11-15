# Private API Reference

The Private API provides access to authenticated trading operations, account management, and personal trading data. These functions require valid exchange API credentials and should be used carefully in production environments.

## Authentication

Before using private API functions, you need to create a credential struct with your exchange API keys.

### Creating Credentials

```elixir
# First, check what credentials are required for your exchange
{:ok, requirements} = ExCcxt.required_credentials("binance")
# Returns: %{"apiKey" => true, "secret" => true, "password" => false, ...}

# Create a credential struct
{:ok, credentials} = ExCcxt.Credential.new([
  name: "binance",
  apiKey: "your_api_key_here",
  secret: "your_secret_key_here"
])
```

### Security Best Practices

**⚠️ IMPORTANT SECURITY CONSIDERATIONS:**

1. **Never hardcode credentials** in your source code
2. **Use environment variables** or secure configuration management
3. **Restrict API key permissions** to only what you need
4. **Use separate credentials** for testing and production
5. **Regularly rotate your API keys**

**Recommended setup:**
```elixir
# In your config/runtime.exs or application startup
credentials = ExCcxt.Credential.new([
  name: "binance",
  apiKey: System.get_env("BINANCE_API_KEY"),
  secret: System.get_env("BINANCE_SECRET_KEY")
])
```

## Account Management

### fetch_balance/2

Fetches your account balance across all currencies.

```elixir
ExCcxt.fetch_balance(credentials, params \\ %{})
```

**Returns:**
```elixir
{:ok, %{
  "BTC" => %{
    "free" => 0.025,      # Available for trading
    "used" => 0.0,        # Currently in open orders
    "total" => 0.025      # Total balance
  },
  "USDT" => %{
    "free" => 1000.0,
    "used" => 500.0,
    "total" => 1500.0
  },
  # ... other currencies
  "info" => %{...}        # Raw exchange response
}}
```

**Example:**
```elixir
case ExCcxt.fetch_balance(credentials) do
  {:ok, balance} -> 
    btc_free = get_in(balance, ["BTC", "free"]) || 0
    IO.puts("Available BTC: #{btc_free}")
  {:error, reason} -> 
    IO.puts("Error fetching balance: #{reason}")
end
```

---

## Order Management

### create_order/7

Creates a new order with full control over order parameters.

```elixir
ExCcxt.create_order(credentials, symbol, type, side, amount, price \\ nil, params \\ %{})
```

**Parameters:**
- `credentials` - Your exchange credentials
- `symbol` - Trading pair (e.g., "BTC/USDT")
- `type` - Order type ("limit", "market", "stop", etc.)
- `side` - Order side ("buy" or "sell")
- `amount` - Order quantity in base currency
- `price` - Order price (required for limit orders)
- `params` - Additional order parameters

**Example:**
```elixir
# Place a limit buy order for 0.001 BTC at $45,000
{:ok, order} = ExCcxt.create_order(
  credentials,
  "BTC/USDT", 
  "limit", 
  "buy", 
  0.001, 
  45000.0
)
```

---

### create_limit_buy_order/5 & create_limit_sell_order/5

Convenience functions for limit orders.

```elixir
# Buy order
ExCcxt.create_limit_buy_order(credentials, symbol, amount, price, params \\ %{})

# Sell order  
ExCcxt.create_limit_sell_order(credentials, symbol, amount, price, params \\ %{})
```

**Example:**
```elixir
# Buy 0.001 BTC at $45,000
{:ok, buy_order} = ExCcxt.create_limit_buy_order(credentials, "BTC/USDT", 0.001, 45000.0)

# Sell 0.001 BTC at $50,000
{:ok, sell_order} = ExCcxt.create_limit_sell_order(credentials, "BTC/USDT", 0.001, 50000.0)
```

---

### create_market_buy_order/4 & create_market_sell_order/4

Market orders execute immediately at current market price.

```elixir
ExCcxt.create_market_buy_order(credentials, symbol, amount, params \\ %{})
ExCcxt.create_market_sell_order(credentials, symbol, amount, params \\ %{})
```

**Example:**
```elixir
# Market buy $100 worth of BTC
{:ok, order} = ExCcxt.create_market_buy_order(credentials, "BTC/USDT", 100.0)
```

---

### create_orders/3

Create multiple orders in a single request (batch orders).

```elixir
ExCcxt.create_orders(credentials, orders, params \\ %{})
```

**Example:**
```elixir
orders = [
  %{symbol: "BTC/USDT", type: "limit", side: "buy", amount: 0.001, price: 45000},
  %{symbol: "ETH/USDT", type: "limit", side: "buy", amount: 0.1, price: 3000}
]

{:ok, created_orders} = ExCcxt.create_orders(credentials, orders)
```

---

### cancel_order/4

Cancel an existing order.

```elixir
ExCcxt.cancel_order(credentials, order_id, symbol, params \\ %{})
```

**Example:**
```elixir
{:ok, cancelled_order} = ExCcxt.cancel_order(credentials, "12345", "BTC/USDT")
```

---

## Order Queries

### fetch_order/4

Fetch details of a specific order.

```elixir
ExCcxt.fetch_order(credentials, order_id, symbol, params \\ %{})
```

---

### fetch_orders/5

Fetch order history with optional filtering.

```elixir
ExCcxt.fetch_orders(credentials, symbol \\ nil, since \\ nil, limit \\ nil, params \\ %{})
```

**Parameters:**
- `symbol` - Filter by trading pair (optional)
- `since` - Unix timestamp to fetch orders from (optional)
- `limit` - Maximum number of orders to return (optional)

---

### fetch_open_orders/5

Fetch currently open orders.

```elixir
ExCcxt.fetch_open_orders(credentials, symbol \\ nil, since \\ nil, limit \\ nil, params \\ %{})
```

---

### fetch_canceled_orders/5 & fetch_closed_orders/5

Fetch canceled or completed orders respectively.

```elixir
ExCcxt.fetch_canceled_orders(credentials, symbol \\ nil, since \\ nil, limit \\ nil, params \\ %{})
ExCcxt.fetch_closed_orders(credentials, symbol \\ nil, since \\ nil, limit \\ nil, params \\ %{})
```

---

## Trading History

### fetch_my_trades/5

Fetch your personal trade history.

```elixir
ExCcxt.fetch_my_trades(credentials, symbol \\ nil, since \\ nil, limit \\ nil, params \\ %{})
```

**Example:**
```elixir
# Fetch last 50 BTC/USDT trades
{:ok, trades} = ExCcxt.fetch_my_trades(credentials, "BTC/USDT", nil, 50)

Enum.each(trades, fn trade ->
  IO.puts("#{trade.side} #{trade.amount} BTC at $#{trade.price}")
end)
```

---

### fetch_my_liquidations/5

Fetch liquidation history (for margin/futures trading).

```elixir
ExCcxt.fetch_my_liquidations(credentials, symbol \\ nil, since \\ nil, limit \\ nil, params \\ %{})
```

---

## Margin Trading

### fetch_cross_borrow_rate/3 & fetch_cross_borrow_rates/2

Fetch borrowing rates for cross-margin trading.

```elixir
ExCcxt.fetch_cross_borrow_rate(credentials, currency_code, params \\ %{})
ExCcxt.fetch_cross_borrow_rates(credentials, params \\ %{})
```

---

### fetch_isolated_borrow_rate/3 & fetch_isolated_borrow_rates/2

Fetch borrowing rates for isolated margin trading.

```elixir
ExCcxt.fetch_isolated_borrow_rate(credentials, symbol, params \\ %{})
ExCcxt.fetch_isolated_borrow_rates(credentials, params \\ %{})
```

---

## Currency Conversion

### create_convert_trade/6

Execute currency conversion trades.

```elixir
ExCcxt.create_convert_trade(
  credentials, 
  quote_id, 
  from_currency, 
  to_currency, 
  amount, 
  params \\ %{}
)
```

---

## Error Handling

Private API functions can return various error types:

### Common Errors

1. **Authentication Errors**
   - Invalid API key/secret
   - Insufficient permissions
   - API key restrictions

2. **Trading Errors**
   - Insufficient balance
   - Invalid order parameters
   - Market closed
   - Minimum order size not met

3. **Rate Limiting**
   - Too many requests
   - Order rate limits exceeded

### Error Handling Example

```elixir
case ExCcxt.create_limit_buy_order(credentials, "BTC/USDT", 0.001, 45000) do
  {:ok, order} -> 
    IO.puts("Order created: #{order["id"]}")
    
  {:error, reason} when is_binary(reason) ->
    cond do
      String.contains?(reason, "insufficient") ->
        IO.puts("Insufficient balance to place order")
      String.contains?(reason, "PRICE_FILTER") ->
        IO.puts("Price doesn't meet exchange requirements")
      String.contains?(reason, "LOT_SIZE") ->
        IO.puts("Order size doesn't meet minimum requirements")
      true ->
        IO.puts("Order failed: #{reason}")
    end
        
  {:error, reason} ->
    IO.puts("Unexpected error: #{inspect(reason)}")
end
```

---

## Best Practices

### 1. Risk Management

```elixir
# Always validate balances before placing orders
defmodule TradingBot do
  def safe_buy_order(credentials, symbol, amount, price) do
    with {:ok, balance} <- ExCcxt.fetch_balance(credentials),
         {:ok, _} <- validate_sufficient_balance(balance, symbol, amount, price) do
      ExCcxt.create_limit_buy_order(credentials, symbol, amount, price)
    end
  end
  
  defp validate_sufficient_balance(balance, symbol, amount, price) do
    [_base, quote] = String.split(symbol, "/")
    required = amount * price
    available = get_in(balance, [quote, "free"]) || 0
    
    if available >= required do
      {:ok, :sufficient}
    else
      {:error, "Insufficient #{quote} balance. Required: #{required}, Available: #{available}"}
    end
  end
end
```

### 2. Order Monitoring

```elixir
defmodule OrderTracker do
  def place_and_monitor_order(credentials, symbol, amount, price) do
    case ExCcxt.create_limit_buy_order(credentials, symbol, amount, price) do
      {:ok, order} ->
        monitor_order(credentials, order["id"], symbol)
      error ->
        error
    end
  end
  
  defp monitor_order(credentials, order_id, symbol) do
    case ExCcxt.fetch_order(credentials, order_id, symbol) do
      {:ok, order} ->
        case order["status"] do
          "open" -> 
            # Order still pending
            Process.sleep(5000) # Wait 5 seconds
            monitor_order(credentials, order_id, symbol)
          "closed" -> 
            {:ok, :filled, order}
          "canceled" -> 
            {:ok, :canceled, order}
        end
      error -> 
        error
    end
  end
end
```

### 3. Position Management

```elixir
defmodule PositionManager do
  def get_positions(credentials) do
    with {:ok, balance} <- ExCcxt.fetch_balance(credentials) do
      positions = 
        balance
        |> Enum.filter(fn {currency, data} -> 
          data["total"] > 0 and currency != "info"
        end)
        |> Map.new()
      
      {:ok, positions}
    end
  end
  
  def close_position(credentials, currency, quote_currency) do
    with {:ok, positions} <- get_positions(credentials),
         amount when amount > 0 <- get_in(positions, [currency, "free"]) do
      symbol = "#{currency}/#{quote_currency}"
      ExCcxt.create_market_sell_order(credentials, symbol, amount)
    else
      _ -> {:error, "No position to close"}
    end
  end
end
```

## Rate Limiting Considerations

Different exchanges have different rate limits for private API calls. Implement appropriate delays:

```elixir
defmodule RateLimiter do
  def with_rate_limit(fun, delay_ms \\ 100) do
    result = fun.()
    Process.sleep(delay_ms)
    result
  end
end

# Usage
orders = ["BTC/USDT", "ETH/USDT", "ADA/USDT"]
|> Enum.map(fn symbol ->
  RateLimiter.with_rate_limit(fn ->
    ExCcxt.fetch_open_orders(credentials, symbol)
  end)
end)
```

## Next Steps

- [Public API Reference](public_api.md) - Learn about market data functions
- [Installation Guide](installation.md) - Setup instructions  
- [Disclaimer](disclaimer.md) - **IMPORTANT: Read before trading**