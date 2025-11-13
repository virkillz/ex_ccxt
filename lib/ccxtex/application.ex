defmodule ExCcxt.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    js_path = Application.app_dir(:ex_ccxt, "priv/js/dist")

    children = [
      %{
        id: NodeJS,
        start: {NodeJS, :start_link, [[path: js_path, pool_size: 16]]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExCcxt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
