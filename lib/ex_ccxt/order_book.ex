defmodule ExCcxt.OrderBook do
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