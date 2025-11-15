defmodule ExCcxt.OrderBook do
  @moduledoc """
  Represents order book data for a trading symbol from a cryptocurrency exchange.
  
  An order book contains the current buy orders (bids) and sell orders (asks) for a trading pair.
  Each bid and ask is represented as a list containing [price, quantity]. This struct is returned
  by order book functions such as `ExCcxt.fetch_order_book/2` and `ExCcxt.fetch_l2_order_book/4`.
  
  ## Fields
  
  - `:symbol` - Trading pair symbol (e.g., "BTC/USDT")
  - `:bids` - List of buy orders as [price, quantity] pairs, sorted by price descending
  - `:asks` - List of sell orders as [price, quantity] pairs, sorted by price ascending
  - `:timestamp` - Unix timestamp in milliseconds when the data was captured
  - `:datetime` - ISO datetime string when the data was captured
  - `:nonce` - Exchange-specific sequence number for ordering updates
  """
  
  use TypedStruct

  typedstruct do
    field :asks, list(list(float()))
    field :bids, list(list(float()))
    field :symbol, String.t()
    field :timestamp, integer()
    field :datetime, String.t()
    field :nonce, integer()
  end
end