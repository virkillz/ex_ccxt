defmodule ExCcxt.OHLCV do
  @moduledoc """
  Represents OHLCV (Open, High, Low, Close, Volume) candlestick data for a trading symbol.
  
  OHLCV data represents price and volume information over a specific time period (candlestick).
  This struct is returned by `ExCcxt.fetch_ohlcvs/1` and contains the essential price points
  and volume for technical analysis.
  
  ## Fields
  
  - `:open` - Opening price for the time period
  - `:high` - Highest price reached during the time period  
  - `:low` - Lowest price reached during the time period
  - `:close` - Closing price for the time period
  - `:base_volume` - Volume traded in base currency during the period
  - `:timestamp` - Unix timestamp in milliseconds for the period start
  """
  
  use TypedStruct

  typedstruct do
    field :open, float()
    field :close, float()
    field :high, float()
    field :low, float()
    field :base_volume, float()
    field :timestamp, integer()
  end
end
