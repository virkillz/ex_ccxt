defmodule ExCcxt.Credential do
  @moduledoc """
  Represents authentication credentials for accessing private APIs on cryptocurrency exchanges.
  
  This struct contains the various authentication parameters that may be required by different
  exchanges for private operations like trading, fetching balances, and order management.
  Use `ExCcxt.Credential.new/1` to create and validate credentials based on exchange requirements.
  
  ## Fields
  
  - `:name` - Exchange name (required, e.g., "binance", "kraken")
  - `:apiKey` - API key credential (boolean field indicating if provided)
  - `:secret` - Secret key credential (boolean field indicating if provided)
  - `:password` - Password/passphrase credential (boolean field indicating if provided)
  - `:login` - Login credential (boolean field indicating if provided)
  - `:uid` - User ID credential (boolean field indicating if provided)
  - `:token` - Token credential (boolean field indicating if provided)
  - `:twofa` - Two-factor authentication credential (boolean field indicating if provided)
  - `:privateKey` - Private key credential (boolean field indicating if provided)
  - `:walletAddress` - Wallet address credential (boolean field indicating if provided)
  
  ## Usage
  
      # Create credentials for an exchange
      {:ok, cred} = ExCcxt.Credential.new(
        name: "binance",
        apiKey: "your_api_key",
        secret: "your_secret"
      )
      
      # Use credentials with private API functions
      ExCcxt.fetch_balance(cred)
  """
  
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
