defmodule ExCcxt.Ticker do
  @moduledoc """
  Represents a ticker (price data) for a trading symbol from a cryptocurrency exchange.
  
  A ticker contains current market information including prices (bid, ask, last, etc.),
  volume data, price changes, and timestamps. This struct is returned by ticker-related
  functions such as `ExCcxt.fetch_ticker/3` and `ExCcxt.fetch_tickers/2`.
  
  ## Fields
  
  - `:symbol` - Trading pair symbol (e.g., "BTC/USDT")
  - `:bid` - Current highest bid price
  - `:ask` - Current lowest ask price  
  - `:last` - Last trade price
  - `:open` - Opening price for the period
  - `:close` - Closing price for the period
  - `:high` - Highest price for the period
  - `:low` - Lowest price for the period
  - `:base_volume` - Volume in base currency
  - `:quote_volume` - Volume in quote currency
  - `:change` - Absolute price change
  - `:percentage` - Percentage price change
  - `:vwap` - Volume-weighted average price
  - `:timestamp` - Unix timestamp in milliseconds
  - `:datetime` - ISO datetime string
  - `:info` - Raw exchange-specific data
  """
  
  use TypedStruct

  typedstruct do
    field :info, map()
    field :ask, float()
    field :bid, float()
    field :open, float()
    field :close, float()
    field :high, float()
    field :low, float()
    field :last, float()
    field :average, float()
    field :change, float()
    field :percentage, float()
    field :base_volume, float()
    field :quote_volume, float()
    field :symbol, String.t()
    field :vwap, float()
    field :datetime, NaiveDateTime.t()
    field :timestamp, integer()
  end
end
