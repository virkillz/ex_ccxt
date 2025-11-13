defmodule ExCcxt.Market do
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
