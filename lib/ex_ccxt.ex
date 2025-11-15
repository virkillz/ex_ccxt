defmodule ExCcxt do
  alias ExCcxt.OhlcvOpts
  alias ExCcxt.{Ticker, OrderBook, Utils, OHLCV, Market, Currency}

  @moduledoc """
  ExCcxt main module
  """

  # =============== PUBLIC =========================

  @doc """
  Fetches a list of all available exchanges

  Example:

  ```elixir
  ExCcxt.exchanges()
  ```

  Return:

  ```elixir
  {:ok, ["aax", "alpaca",  "coincheck", "coinex", "okex5", "okx", "paymium", ...]}
  ```

  """
  @spec exchanges() :: {:ok, list(String.t())} | {:error, term}
  def exchanges() do
    with {:ok, exchanges} <- call_js_main(:exchanges, []) do
      {:ok, exchanges}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches a ticker for a particular trading symbol.

  Example:

  ```elixir
  ExCcxt.fetch_ticker("hitbtc", "BTC", "USDT")
  ```


  Return:

  ```elixir
  {:ok,
  %ExCcxt.Ticker{
   timestamp: 1763033564893,
   datetime: "2025-11-13T11:32:44.893Z",
   vwap: 102835.09937889625,
   symbol: "BTC/USDT",
   quote_volume: 96485861.8715014,
   base_volume: 938.25807,
   percentage: -1.8591945763136015,
   change: -1949.47,
   average: 103880.885,
   last: 102906.15,
   low: 100842.93,
   high: 105331.15,
   close: 102906.15,
   open: 104855.62,
   bid: 102869,
   ask: 102916.64,
   info: %{
     high: "105331.15",
     low: "100842.93",
     open: "104855.62",
     timestamp: "2025-11-13T11:32:44.893Z",
     last: "102906.15",
     symbol: "BTCUSD",
     ask: "102916.64",
     bid: "102869.00",
     volume: "938.25807",
     volume_quote: "96485861.8715014"
   }
  }}
  ```

  """
  @spec fetch_ticker(String.t(), String.t(), String.t()) :: {:ok, Ticker.t()} | {:error, term}
  def fetch_ticker(exchange, base, quote) do
    opts = %{
      exchange: exchange,
      symbol: base <> "/" <> quote
    }

    with {:ok, ticker} <- call_js_main(:fetchTicker, [opts]) do
      to_struct = &struct!(Ticker, &1)

      ticker =
        ticker
        |> MapKeys.to_snake_case()
        |> MapKeys.to_atoms_unsafe!()
        |> to_struct.()

      {:ok, ticker}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches an order book for a particular trading symbol.

  Example:

  ```elixir
  ExCcxt.fetch_order_book("hitbtc", "BTC/USDT")
  ```

  Return:

  ```elixir
  {:ok,
  %ExCcxt.OrderBook{
   asks: [[102916.64, 0.2603], [102920.3, 0.19285]],
   bids: [[102869.00, 1.0234], [102865.12, 0.5678]],
   symbol: "BTC/USDT",
   timestamp: 1763033564893,
   datetime: "2025-11-13T11:32:44.893Z",
   nonce: nil
  }}
  ```

  """

  @spec fetch_order_book(String.t(), String.t()) :: {:ok, OrderBook.t()} | {:error, term}
  def fetch_order_book(exchange, symbol) do
    opts = %{
      exchange: exchange,
      symbol: symbol
    }

    with {:ok, order_book} <- call_js_main(:fetchOrderBook, [opts]) do
      order_book =
        order_book
        |> MapKeys.to_snake_case()
        |> MapKeys.to_atoms_unsafe!()
        |> (&struct!(OrderBook, &1)).()

      {:ok, order_book}
    else
      err_tup -> err_tup
    end
  end

  def fetch_ohlcvs(%OhlcvOpts{} = opts) do
    since_unix =
      if opts.since do
        opts.since
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix(:millisecond)
      end

    opts =
      opts
      |> Map.from_struct()
      |> Map.put(:since, since_unix)

    with {:ok, ohlcvs} <- call_js_main(:fetchOhlcvs, [opts]) do
      ohlcvs =
        ohlcvs
        |> Utils.parse_ohlcvs()
        |> Enum.map(&struct!(OHLCV, &1))

      {:ok, ohlcvs}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches a list of all available tickers from an exchange and returns an array of tickers (objects with properties such as symbol, base, quote etc.). Some exchanges do not have means for obtaining a list of tickers via their online API. For those, the list of tickers is hardcoded.

  Example:

  ```elixir
  ExCcxt.fetch_tickers("hitbtc")
  ```

  Return:

  ```elixir
  {:ok,
  %{
   "D2T/USDT" => %ExCcxt.Ticker{
     timestamp: 1763034966000,
     datetime: "2025-11-13T11:56:06.000Z",
     vwap: nil,
     symbol: "D2T/USDT",
     quote_volume: 0,
     base_volume: 0,
     percentage: 0,
     change: 0,
     average: 0.0005,
     last: 0.0005,
     low: 0.0005,
     high: 0.0005,
     close: 0.0005,
     open: 0.0005,
     bid: 0.0005,
     ask: 0.00273,
     info: %{
       high: "0.000500",
       low: "0.000500",
       open: "0.000500",
       timestamp: "2025-11-13T11:56:06.000Z",
       last: "0.000500",
       symbol: "D2TUSDT",
       ask: "0.002730",
       bid: "0.000500",
       volume: "0",
       volume_quote: "0"
     }
   }
  }}
  ```

  """

  @spec fetch_tickers(String.t(), map) :: {:ok, map()} | {:error, term}
  def fetch_tickers(exchange, _params \\ %{}) do
    with {:ok, tickers} <- call_js_main(:fetchTickersAll, [exchange]) do
      to_struct = &struct!(Ticker, &1)

      tickers =
        tickers
        |> Enum.map(fn {k, v} ->
          value =
            v
            |> MapKeys.to_snake_case()
            |> MapKeys.to_atoms_unsafe!()
            |> to_struct.()

          {k, value}
        end)
        |> Map.new()

      {:ok, tickers}
    else
      err_tup -> process_error(err_tup)
    end
  end

  @doc """
  Fetches a list of all available markets from an exchange and returns an array of markets (objects with properties such as symbol, base, quote etc.). Some exchanges do not have means for obtaining a list of markets via their online API. For those, the list of markets is hardcoded.

  Example:

  ```elixir
  ExCcxt.fetch_markets("hitbtc")
  ```

  Return:

  ```elixir
  {:ok, [
    %ExCcxt.Market{
      active: true,
      base: "BTC",
      base_id: "BTC",
      symbol: "BTC/USDT",
      quote: "USDT",
      quote_id: "USD",
      type: "spot",
      spot: true,
      margin: false,
      maker: 0.0012,
      taker: 0.0025
    }, ...
  ]}
  ```

  """

  @spec fetch_markets(String.t()) :: {:ok, list(Market.t())} | {:error, term}
  def fetch_markets(exchange) do
    with {:ok, markets} <- call_js_main(:fetchMarkets, [exchange]) do
      markets =
        markets
        |> Enum.map(fn market ->
          market
          |> MapKeys.to_snake_case()
          |> MapKeys.to_atoms_unsafe!()
          |> (&struct!(Market, &1)).()
        end)

      {:ok, markets}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches all available currencies from an exchange.

  Example:

  ```elixir
  ExCcxt.fetch_currencies("hitbtc")
  ```

  Return:

  ```elixir
  {:ok, %{
    "BTC" => %ExCcxt.Currency{
      active: true,
      code: "BTC",
      deposit: true,
      fee: 0.0005,
      id: "BTC",
      info: %{
        "crypto" => true,
        "delisted" => false,
        "fullName" => "Bitcoin",
        "id" => "BTC",
        "payinConfirmations" => "1",
        "payinEnabled" => true,
        "payinPaymentId" => false,
        "payoutEnabled" => true,
        "payoutFee" => "0.000500000000",
        "payoutIsPaymentId" => false,
        "precisionPayout" => "8",
        "precisionTransfer" => "8",
        "transferEnabled" => true
      },
      limits: %{"amount" => %{}, "withdraw" => %{}},
      name: "Bitcoin",
      payin: true,
      payout: true,
      precision: 1.0e-8,
      transfer: true,
      type: "crypto",
      withdraw: true
    },
    ...
  }}
  ```

  """
  @spec fetch_currencies(String.t()) :: {:ok, map()} | {:error, term}
  def fetch_currencies(exchange) do
    with {:ok, currencies} <- call_js_main(:fetchCurrencies, [exchange]) do
      currencies =
        currencies
        |> Enum.map(fn {k, v} ->
          currency =
            v
            |> MapKeys.to_snake_case()
            |> MapKeys.to_atoms_unsafe!()
            |> (&struct!(Currency, &1)).()

          {k, currency}
        end)
        |> Map.new()

      {:ok, currencies}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Returns the list of markets as an object indexed by symbol and caches it with the exchange instance.
  Returns cached markets if loaded already, unless the reload = true flag is forced.

  Example:

    ```elixir
    ExCcxt.load_markets("hitbtc")
    ```

  Return:

  ```elixir
  {:ok, %{
    "D2T/USDT" => %ExCcxt.Market{
      active: true,
      base: "D2T",
      base_id: "D2T",
      contract: false,
      fee_currency: "USDT",
      future: false,
      id: "D2TUSDT",
      info: %{
        "baseCurrency" => "D2T",
        "feeCurrency" => "USD",
        "id" => "D2TUSDT",
        "provideLiquidityRate" => "0.0012",
        "quantityIncrement" => "1",
        "quoteCurrency" => "USD",
        "takeLiquidityRate" => "0.0025",
        "tickSize" => "0.000001"
      },
      limits: %{"amount" => %{"min" => 1}, "cost" => %{"min" => 1.0e-6}, "leverage" => %{}, "price" => %{"min" => 1.0e-6}},
      maker: 0.0012,
      margin: false,
      option: false,
      percentage: true,
      precision: %{"amount" => 1, "price" => 1.0e-6},
      quote: "USDT",
      quote_id: "USD",
      spot: true,
      swap: false,
      symbol: "D2T/USDT",
      taker: 0.0025,
      tier_based: false,
      type: "spot"
    },
    ...
  }}
  ```

  """
  @spec load_markets(String.t(), boolean()) :: {:ok, map()} | {:error, term}
  def load_markets(exchange, reload \\ false) do
    with {:ok, markets} <- call_js_main(:loadMarkets, [exchange, reload]) do
      {:ok, markets}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Returns information regarding the exchange status from either the info hardcoded
  in the exchange instance or the API, if available.

  Example:
  ```
  iex(7)> ExCcxt.fetch_status("hitbtc")
  {:ok, %{"status" => "ok"}}
  iex(8)> ExCcxt.fetch_status("indodax")
  {:ok, %{"status" => "ok", "updated" => 1763037264132}}
  iex(9)> ExCcxt.fetch_status("binance")
  {:ok, %{"info" => %{"msg" => "normal", "status" => "0"}, "status" => "ok"}}
  iex(10)> ExCcxt.fetch_status("poloniex")
  {:ok, %{"status" => "ok", "updated" => 1763037295451}}
  ```


  """
  @spec fetch_status(String.t(), map()) :: {:ok, map()} | {:error, term}
  def fetch_status(exchange, params \\ %{}) do
    with {:ok, status} <- call_js_main(:fetchStatus, [exchange, params]) do
      {:ok, status}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetch L2 (price-aggregated) order book for a particular symbol.

  Example:
  ```elixir
  iex> ExCcxt.fetch_l2_order_book("binance", "BTC/USDT")
  {:ok,
  %ExCcxt.OrderBook{
   nonce: nil,
   datetime: nil,
   timestamp: nil,
   symbol: "BTC/USDT",
   bids: [
     [99417.13, 0.00619],
     [99415.58, 0.02367],
     [99410.61, 0.11293],
     [99405.71, 0.0676],
     [99405.65, 0.25248],
     [99405.63, 0.03151],
     [99400.79, 0.26741],
     [99400.67, 0.50107],
     [99398.21, 0.33522],
     [99397.75, 0.14666],
     [99397.23, 1.34068],
     [99395.77, 0.07108],
     [99374.95, 0.13494],
     [99360.79, 1.60834],
     [99348.07, 0.39802],
     [99348.04, 0.54288],
     [99343.14, 0.2372],
     [99343.07, 0.92248],
     [99338.1, 0.40459],
     [99333.34, 0.66522],
     [99329.09, 1.03216],
     [99328.45, 0.60465],
     [99328.37, 0.87363],
     [99323.16, 1.29009],
     [99314.84, 0.05501],
     [99309.76, 2.37415],
     [99296.5, 1.72206],
     [99254.78, 3.27986],
     [99251.68, 2.72735],
     [99204.84, 5.00355],
     [99105.4, 9.96622],
     ...
   ],
   ...
  }}
  ```

  """
  @spec fetch_l2_order_book(String.t(), String.t(), integer() | nil, map()) ::
          {:ok, OrderBook.t()} | {:error, term}
  def fetch_l2_order_book(exchange, symbol, limit \\ nil, params \\ %{}) do
    with {:ok, order_book} <- call_js_main(:fetchL2OrderBook, [exchange, symbol, limit, params]) do
      order_book =
        order_book
        |> MapKeys.to_snake_case()
        |> MapKeys.to_atoms_unsafe!()
        |> (&struct!(OrderBook, &1)).()

      {:ok, order_book}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetch recent trades for a particular trading symbol.


  TODO: FIX it says fetchTrades is not a constructor

  """
  @spec fetch_trades(String.t(), String.t(), String.t(), integer() | nil) ::
          {:ok, list()} | {:error, term}
  def fetch_trades(exchange, base, quote, since \\ nil) do
    opts = %{
      exchange: exchange,
      base: base,
      quote: quote,
      since: since
    }

    with {:ok, trades} <- call_js_main(:fetchTrades, [opts]) do
      {:ok, trades}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetch open interest for a particular symbol.
  """
  @spec fetch_open_interest(String.t(), String.t(), map()) :: {:ok, map()} | {:error, term}
  def fetch_open_interest(exchange, symbol, params \\ %{}) do
    with {:ok, open_interest} <- call_js_main(:fetchOpenInterest, [exchange, symbol, params]) do
      {:ok, open_interest}
    else
      err_tup -> err_tup
    end
  end

  def fetch_volatility_history(exchange, code, params \\ %{}) do
    with {:ok, volatility} <- call_js_main(:fetchVolatilityHistory, [exchange, code, params]) do
      {:ok, volatility}
    else
      err_tup -> err_tup
    end
  end

  def fetch_underlying_assets(exchange) do
    with {:ok, assets} <- call_js_main(:fetchUnderlyingAssets, [exchange]) do
      {:ok, assets}
    else
      err_tup -> err_tup
    end
  end

  def fetch_settlement_history(exchange, symbol, since \\ nil, limit \\ nil, params \\ %{}) do
    with {:ok, history} <-
           call_js_main(:fetchSettlementHistory, [exchange, symbol, since, limit, params]) do
      {:ok, history}
    else
      err_tup -> err_tup
    end
  end

  def fetch_liquidations(exchange, symbol, since \\ nil, limit \\ nil, params \\ %{}) do
    with {:ok, liquidations} <-
           call_js_main(:fetchLiquidations, [exchange, symbol, since, limit, params]) do
      {:ok, liquidations}
    else
      err_tup -> err_tup
    end
  end

  def fetch_greeks(exchange, symbol, params \\ %{}) do
    with {:ok, greeks} <- call_js_main(:fetchGreeks, [exchange, symbol, params]) do
      {:ok, greeks}
    else
      err_tup -> err_tup
    end
  end

  def fetch_all_greeks(exchange, symbols, params \\ %{}) do
    with {:ok, greeks} <- call_js_main(:fetchAllGreeks, [exchange, symbols, params]) do
      {:ok, greeks}
    else
      err_tup -> err_tup
    end
  end

  def fetch_option(exchange, symbol, params \\ %{}) do
    with {:ok, option} <- call_js_main(:fetchOption, [exchange, symbol, params]) do
      {:ok, option}
    else
      err_tup -> err_tup
    end
  end

  def fetch_option_chain(exchange, code, params \\ %{}) do
    with {:ok, chain} <- call_js_main(:fetchOptionChain, [exchange, code, params]) do
      {:ok, chain}
    else
      err_tup -> err_tup
    end
  end

  def fetch_convert_quote(exchange, from_code, to_code, amount, params \\ %{}) do
    with {:ok, quote} <-
           call_js_main(:fetchConvertQuote, [exchange, from_code, to_code, amount, params]) do
      {:ok, quote}
    else
      err_tup -> err_tup
    end
  end

  def fetch_funding_rate(exchange, symbol, params \\ %{}) do
    with {:ok, rate} <- call_js_main(:fetchFundingRate, [exchange, symbol, params]) do
      {:ok, rate}
    else
      err_tup -> err_tup
    end
  end

  def fetch_funding_rates(exchange, symbols \\ nil, params \\ %{}) do
    with {:ok, rates} <- call_js_main(:fetchFundingRates, [exchange, symbols, params]) do
      {:ok, rates}
    else
      err_tup -> err_tup
    end
  end

  def fetch_funding_rate_history(exchange, symbol, since \\ nil, limit \\ nil, params \\ %{}) do
    with {:ok, history} <-
           call_js_main(:fetchFundingRateHistory, [exchange, symbol, since, limit, params]) do
      {:ok, history}
    else
      err_tup -> err_tup
    end
  end

  # TODO: Fix this, it says it's not a function
  def fetch_funding_rate_interval(exchange, symbol, params \\ %{}) do
    with {:ok, interval} <- call_js_main(:fetchFundingRateInterval, [exchange, symbol, params]) do
      {:ok, interval}
    else
      err_tup -> err_tup
    end
  end

  # TODO: Fix this, it says it's not a function
  def fetch_funding_rate_intervals(exchange, symbols, params \\ %{}) do
    with {:ok, intervals} <- call_js_main(:fetchFundingRateIntervals, [exchange, symbols, params]) do
      {:ok, intervals}
    else
      err_tup -> err_tup
    end
  end

  # TODO: Fix this, it says it's not a function
  def fetch_long_short_ratio(exchange, symbol, params \\ %{}) do
    with {:ok, ratio} <- call_js_main(:fetchLongShortRatio, [exchange, symbol, params]) do
      {:ok, ratio}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Get credentials requirement to access the private API. Most common are 'apiKey' and 'secret'.
  To get apiKey and secret, check your exchanges setting page.

  Example:
  ```elixir
  iex> ExCcxt.required_credentials("binance")

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
  """

  @spec required_credentials(String.t()) :: {:ok, map()} | {:error, term}
  def required_credentials(exchange) do
    with {:ok, credentials} <- call_js_main(:requiredCredentials, [exchange]) do
      {:ok, credentials}
    else
      err_tup -> err_tup
    end
  end

  # =============== PRIVATE ========================

  def fetch_balance(credential = %ExCcxt.Credential{}, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, balance} <- call_js_main(:fetchBalance, [exchange, cred, params]) do
      {:ok, balance}
    else
      err_tup -> err_tup
    end
  end

  def create_order(
        credential = %ExCcxt.Credential{},
        symbol,
        type,
        side,
        amount,
        price \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <-
           call_js_main(:createOrder, [exchange, cred, symbol, type, side, amount, price, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def create_orders(credential = %ExCcxt.Credential{}, orders, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, orders} <- call_js_main(:createOrders, [exchange, cred, orders, params]) do
      {:ok, orders}
    else
      err_tup -> err_tup
    end
  end

  def create_limit_buy_order(
        credential = %ExCcxt.Credential{},
        symbol,
        amount,
        price,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <-
           call_js_main(:createLimitBuyOrder, [exchange, cred, symbol, amount, price, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def create_limit_sell_order(
        credential = %ExCcxt.Credential{},
        symbol,
        amount,
        price,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <-
           call_js_main(:createLimitSellOrder, [exchange, cred, symbol, amount, price, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def create_market_buy_order(credential = %ExCcxt.Credential{}, symbol, amount, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <-
           call_js_main(:createMarketBuyOrder, [exchange, cred, symbol, amount, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def create_market_sell_order(credential = %ExCcxt.Credential{}, symbol, amount, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <-
           call_js_main(:createMarketSellOrder, [exchange, cred, symbol, amount, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def cancel_order(credential = %ExCcxt.Credential{}, id, symbol, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <- call_js_main(:cancelOrder, [exchange, cred, id, symbol, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def fetch_order(credential = %ExCcxt.Credential{}, id, symbol, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, order} <- call_js_main(:fetchOrder, [exchange, cred, id, symbol, params]) do
      {:ok, order}
    else
      err_tup -> err_tup
    end
  end

  def fetch_orders(
        credential = %ExCcxt.Credential{},
        symbol \\ nil,
        since \\ nil,
        limit \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, orders} <-
           call_js_main(:fetchOrders, [exchange, cred, symbol, since, limit, params]) do
      {:ok, orders}
    else
      err_tup -> err_tup
    end
  end

  def fetch_open_orders(
        credential = %ExCcxt.Credential{},
        symbol \\ nil,
        since \\ nil,
        limit \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, orders} <-
           call_js_main(:fetchOpenOrders, [exchange, cred, symbol, since, limit, params]) do
      {:ok, orders}
    else
      err_tup -> err_tup
    end
  end

  def fetch_canceled_orders(
        credential = %ExCcxt.Credential{},
        symbol \\ nil,
        since \\ nil,
        limit \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, orders} <-
           call_js_main(:fetchCanceledOrders, [exchange, cred, symbol, since, limit, params]) do
      {:ok, orders}
    else
      err_tup -> err_tup
    end
  end

  def fetch_closed_orders(
        credential = %ExCcxt.Credential{},
        symbol \\ nil,
        since \\ nil,
        limit \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, orders} <-
           call_js_main(:fetchClosedOrders, [exchange, cred, symbol, since, limit, params]) do
      {:ok, orders}
    else
      err_tup -> err_tup
    end
  end

  def fetch_my_trades(
        credential = %ExCcxt.Credential{},
        symbol \\ nil,
        since \\ nil,
        limit \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, trades} <-
           call_js_main(:fetchMyTrades, [exchange, cred, symbol, since, limit, params]) do
      {:ok, trades}
    else
      err_tup -> err_tup
    end
  end

  def fetch_my_liquidations(
        credential = %ExCcxt.Credential{},
        symbol \\ nil,
        since \\ nil,
        limit \\ nil,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, liquidations} <-
           call_js_main(:fetchMyLiquidations, [exchange, cred, symbol, since, limit, params]) do
      {:ok, liquidations}
    else
      err_tup -> err_tup
    end
  end

  def fetch_cross_borrow_rate(credential = %ExCcxt.Credential{}, code, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, rate} <- call_js_main(:fetchCrossBorrowRate, [exchange, cred, code, params]) do
      {:ok, rate}
    else
      err_tup -> err_tup
    end
  end

  def fetch_cross_borrow_rates(credential = %ExCcxt.Credential{}, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, rates} <- call_js_main(:fetchCrossBorrowRates, [exchange, cred, params]) do
      {:ok, rates}
    else
      err_tup -> err_tup
    end
  end

  def fetch_isolated_borrow_rate(credential = %ExCcxt.Credential{}, symbol, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, rate} <- call_js_main(:fetchIsolatedBorrowRate, [exchange, cred, symbol, params]) do
      {:ok, rate}
    else
      err_tup -> err_tup
    end
  end

  def fetch_isolated_borrow_rates(credential = %ExCcxt.Credential{}, params \\ %{}) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, rates} <- call_js_main(:fetchIsolatedBorrowRates, [exchange, cred, params]) do
      {:ok, rates}
    else
      err_tup -> err_tup
    end
  end

  def create_convert_trade(
        credential = %ExCcxt.Credential{},
        id,
        from_code,
        to_code,
        amount,
        params \\ %{}
      ) do
    with %{exchange: exchange, cred: cred} <- shorten_credential(credential),
         {:ok, trade} <-
           call_js_main(:createConvertTrade, [
             exchange,
             cred,
             id,
             from_code,
             to_code,
             amount,
             params
           ]) do
      {:ok, trade}
    else
      err_tup -> err_tup
    end
  end

  # =============== HELPERS ========================

  defp shorten_credential(credential = %ExCcxt.Credential{}) do
    cred =
      credential
      |> Map.from_struct()
      |> Enum.filter(fn {k, v} -> not is_nil(v) end)
      |> Map.new()
      |> Map.delete(:name)

    %{exchange: credential.name, cred: cred}
  end

  defp call_js_main(jsfn, args) do
    NodeJS.call({"exec.js", jsfn}, args)
  end

  @spec process_error({:error, String.t()}) :: {:error, String.t()}
  defp process_error(errtup = {:error, reason}) do
    cond do
      String.contains?(reason, "fetchTickers not supported") ->
        {:error, "fetchTickers not supported"}

      true ->
        errtup
    end
  end
end
