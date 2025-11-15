defmodule ExCcxt.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ccxt,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExCcxt.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:nodejs, "~> 3.0"},
      {:jason, "~> 1.4"},
      {:typed_struct, "~> 0.3"},
      {:map_keys, "~> 0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :ex_ccxt,
      files: ["lib", "mix.exs", "README*", "LICENSE*", "priv/js/dist"],
      description: "Use ccxt (cryptocurrency trading library) with Elixir",
      maintainers: ["virkillz"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/virkillz/ex_ccxt",
        "CAMP" => "https://campinvestment.com",
        "Ccxt" => "https://github.com/ccxt/ccxt"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "guides/overview.md",
        "guides/installation.md",
        "guides/public_api.md",
        "guides/private_api.md",
        "guides/disclaimer.md"
      ],
      groups_for_extras: [
        Guides: ~r/guides\/.*/
      ]
    ]
  end
end
