defmodule ExCcxt.Currency do
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