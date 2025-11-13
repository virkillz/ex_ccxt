defmodule ExCcxt.Credential do
  use TypedStruct

  typedstruct do
    field :name, String.t()
    field :apiKey, boolean()
    field :login, boolean()
    field :password, boolean()
    field :privateKey, boolean()
    field :secret, boolean()
    field :token, boolean()
    field :twofa, boolean()
    field :uid, boolean()
    field :walletAddress, boolean()
  end

  def new(keywords) do
    cred = __struct__(keywords)

    if is_nil(cred.name) do
      {:error, "name is required"}
    else
      case ExCcxt.required_credentials(cred.name) do
        {:ok, required_credentials} ->
          requirement =
            Enum.filter(required_credentials, fn {k, v} ->
              v
            end)
            |> Enum.map(fn {k, _} -> String.to_atom(k) end)

          sufficient_credentials =
            requirement
            |> Enum.map(fn k -> Map.get(cred, k) end)
            |> Enum.all?(fn v -> not is_nil(v) end)

          if sufficient_credentials do
            {:ok, cred}
          else
            {:error, "missing credential: #{inspect(requirement)}"}
          end

        _ ->
          {:error, "cannot obtain required credentials information"}
      end
    end
  end
end
