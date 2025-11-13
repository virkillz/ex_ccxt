defmodule ExCcxt.Market do
  use TypedStruct

  typedstruct do
    field :active, boolean()
    field :base, String.t()
    field :base_id, String.t()
    field :id, String.t()
    field :info, map()
    field :limits, map()
    field :precision, map()
    field :quote, String.t()
    field :quote_id, String.t()
    field :symbol, String.t()
    field :symbol_id, String.t()
    field :altname, String.t()
    field :darkpool, boolean()
    field :maker, float()
    field :taker, float()
    field :type, String.t()
    field :swap, boolean()
    field :option, boolean()
    field :contract, boolean()
    field :delivery, boolean()
    field :future, boolean()
    field :lowercase_id, String.t()
    # field :margin, boolean()
    # field :spot, boolean()
  end
end
