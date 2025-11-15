defmodule ExCcxt.Application do
  @moduledoc """
  Application module for ExCcxt.

  This module is responsible for starting the ExCcxt application and supervising
  the NodeJS process pool that enables communication with the CCXT JavaScript library.

  The application starts a supervised NodeJS process pool with 16 workers to handle
  concurrent JavaScript function calls for interacting with cryptocurrency exchanges.
  """
  
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
