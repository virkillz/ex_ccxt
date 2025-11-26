defmodule ExCcxt.Helper do
  @moduledoc """
  Development helper functions for the ExCcxt project.

  This module contains utility functions for testing, debugging, and development workflows.
  It includes functions for saving API responses to files and bulk operations across
  multiple exchanges for development and testing purposes.

  Note: This module is intended for development use and may not be part of the public API.
  """

  @exchange_list [
    "hollaex",
    "hitbtc",
    "bitmex",
    "bitstamp",
    "novadax",
    "phemex",
    "hitbtc3",
    "bequant",
    "blockchaincom",
    "bitbank",
    "bitopro",
    "btcalpha",
    "btcturk",
    "bitcoincom",
    "alpaca",
    "ndax",
    "upbit",
    "poloniex",
    "delta",
    "binance",
    "exmo",
    "bitflyer",
    "luno",
    "probit",
    "ascendex",
    "bitfinex",
    "latoken",
    "wazirx",
    "btcmarkets",
    "whitebit",
    "fmfwio",
    "lbank2",
    "btctradeua",
    "yobit",
    "buda",
    "timex",
    "bithumb",
    "bitget",
    "binancecoinm",
    "binanceusdm",
    "huobi",
    "bitrue",
    "bitvavo",
    "okx",
    "digifinex",
    "huobipro",
    "kucoinfutures",
    "kraken",
    "coinbaseprime",
    "kucoin",
    "indodax",
    "gate"
  ]

  def save({:ok, data}, filename) do
    path = "priv/example/#{filename}_success.txt"
    string = inspect(data)

    File.write!(path, string)
  end

  def save({:error, data}, filename) do
    path = "priv/example/#{filename}_error.txt"
    string = inspect(data)

    File.write!(path, string)
  end

  def get_all_currencies() do
    @exchange_list
    |> Enum.each(fn x -> ExCcxt.fetch_ticker(x, "BTC", "USDT") |> save("tickers_#{x}") end)
  end

  def test_olhcvs() do
    @exchange_list
    |> Enum.each(fn x ->
      opts = %ExCcxt.OhlcvOpts{
        exchange: x,
        base: "BTC",
        quote: "USDT",
        timeframe: "1h",
        limit: 100
      }

      ExCcxt.fetch_ohlcvs(opts) |> save("ohlcvs_#{x}")
    end)
  end
end
