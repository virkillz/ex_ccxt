defmodule ExCcxt.Market do
  @moduledoc """
  Represents market information for a trading pair on a cryptocurrency exchange.
  
  A market contains metadata about a trading pair including fees, limits, precision,
  and trading capabilities. This struct is returned by market-related functions such as
  `ExCcxt.fetch_markets/1` and `ExCcxt.load_markets/2`.
  
  ## Fields
  
  - `:symbol` - Trading pair symbol (e.g., "BTC/USDT")
  - `:base` - Base currency code (e.g., "BTC")
  - `:quote` - Quote currency code (e.g., "USDT") 
  - `:active` - Whether the market is currently active for trading
  - `:type` - Market type (e.g., "spot", "future", "option")
  - `:spot` - Whether this is a spot market
  - `:margin` - Whether margin trading is available
  - `:future` - Whether this is a futures market
  - `:option` - Whether this is an options market
  - `:contract` - Whether this is a contract market
  - `:swap` - Whether this is a perpetual swap market
  - `:maker` - Maker fee rate (as decimal, e.g., 0.001 for 0.1%)
  - `:taker` - Taker fee rate (as decimal, e.g., 0.001 for 0.1%)
  - `:percentage` - Whether fees are percentage-based
  - `:tier_based` - Whether fees are tier-based
  - `:precision` - Price and amount precision information
  - `:limits` - Trading limits for amounts and prices
  - `:info` - Raw exchange-specific market data
  """
  
  use TypedStruct

  typedstruct do
    field :active, boolean()
    field :base, String.t()
    field :base_id, String.t()
    field :contract, boolean()
    field :fee_currency, String.t()
    field :future, boolean()
    field :id, String.t()
    field :info, map()
    field :limits, map()
    field :maker, float()
    field :margin, boolean()
    field :option, boolean()
    field :percentage, boolean()
    field :precision, map()
    field :quote, String.t()
    field :quote_id, String.t()
    field :spot, boolean()
    field :swap, boolean()
    field :symbol, String.t()
    field :taker, float()
    field :tier_based, boolean()
    field :type, String.t()
  end
end
