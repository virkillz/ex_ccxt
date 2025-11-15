defmodule ExCcxt.OhlcvOpts do
  @moduledoc """
  Options struct for fetching OHLCV (candlestick) data from cryptocurrency exchanges.
  
  This struct is used as a parameter to `ExCcxt.fetch_ohlcvs/1` to specify the exchange,
  trading pair, timeframe, and other options for retrieving historical price data.
  
  ## Fields
  
  - `:exchange` - Exchange name (required, e.g., "binance", "kraken")
  - `:base` - Base currency code (required, e.g., "BTC", "ETH")
  - `:quote` - Quote currency code (required, e.g., "USDT", "USD")
  - `:timeframe` - Candlestick timeframe (optional, e.g., "1m", "5m", "1h", "1d")
  - `:since` - Start time for data retrieval (optional, NaiveDateTime)
  - `:limit` - Maximum number of candlesticks to return (optional)
  
  ## Usage
  
      opts = %ExCcxt.OhlcvOpts{
        exchange: "binance",
        base: "BTC", 
        quote: "USDT",
        timeframe: "1h",
        limit: 100
      }
      
      {:ok, ohlcvs} = ExCcxt.fetch_ohlcvs(opts)
  """
  
  use TypedStruct

  typedstruct do
    field :exchange, String.t(), enforce: true
    field :base, String.t(), enforce: true
    field :quote, String.t(), enforce: true
    field :timeframe, String.t()
    field :since, NaiveDateTime.t()
    field :limit, integer()
  end
end
