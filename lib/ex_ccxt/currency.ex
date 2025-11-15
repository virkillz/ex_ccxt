defmodule ExCcxt.Currency do
  @moduledoc """
  Represents currency information from a cryptocurrency exchange.
  
  A currency contains metadata about a specific digital or fiat currency supported by an exchange,
  including deposit/withdrawal capabilities, fees, precision, and limits. This struct is returned
  by `ExCcxt.fetch_currencies/1`.
  
  ## Fields
  
  - `:code` - Currency code (e.g., "BTC", "ETH", "USDT")
  - `:name` - Full currency name (e.g., "Bitcoin", "Ethereum")
  - `:active` - Whether the currency is currently active on the exchange
  - `:type` - Currency type (e.g., "crypto", "fiat")
  - `:deposit` - Whether deposits are enabled
  - `:withdraw` - Whether withdrawals are enabled
  - `:payin` - Whether deposits (payin) are enabled
  - `:payout` - Whether withdrawals (payout) are enabled
  - `:transfer` - Whether transfers are enabled
  - `:fee` - Withdrawal fee amount
  - `:precision` - Precision for amounts (smallest unit)
  - `:limits` - Deposit and withdrawal limits
  - `:info` - Raw exchange-specific currency data
  """
  
  use TypedStruct

  typedstruct do
    field :active, boolean()
    field :code, String.t()
    field :deposit, boolean()
    field :fee, float()
    field :id, String.t()
    field :info, map()
    field :limits, map()
    field :name, String.t()
    field :payin, boolean()
    field :payout, boolean()
    field :precision, float()
    field :transfer, boolean()
    field :type, String.t()
    field :withdraw, boolean()
  end
end