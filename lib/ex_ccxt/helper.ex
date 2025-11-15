defmodule ExCcxt.Helper do
  @moduledoc """
  Development helper functions for the ExCcxt project.

  This module contains utility functions for testing, debugging, and development workflows.
  It includes functions for saving API responses to files and bulk operations across
  multiple exchanges for development and testing purposes.

  Note: This module is intended for development use and may not be part of the public API.
  """
  def save({:ok, data}, filename) do
    path = "priv/example/#{filename}.txt"
    string = inspect(data)

    File.write!(path, string)
  end

  def save(result, _) do
    IO.inspect(result)
    result
  end

  def get_all_market() do
    all_exchanges = [
      "aax",
      "alpaca",
      "ascendex",
      "bequant",
      "bibox",
      "bigone",
      "binance",
      "binancecoinm",
      "binanceus",
      "binanceusdm",
      "bit2c",
      "bitbank",
      "bitbay",
      "bitbns",
      "bitcoincom",
      "bitfinex",
      "bitfinex2",
      "bitflyer",
      "bitforex",
      "bitget",
      "bithumb",
      "bitmart",
      "bitmex",
      "bitopro",
      "bitpanda",
      "bitrue",
      "bitso",
      "bitstamp",
      "bitstamp1",
      "bittrex",
      "bitvavo",
      "bkex",
      "bl3p",
      "blockchaincom",
      "btcalpha",
      "btcbox",
      "btcex",
      "btcmarkets",
      "btctradeua",
      "btcturk",
      "buda",
      "bw",
      "bybit",
      "bytetrade",
      "cex",
      "coinbase",
      "coinbaseprime",
      "coinbasepro",
      "coincheck",
      "coinex",
      "coinfalcon",
      "coinmate",
      "coinone",
      "coinspot",
      "crex24",
      "cryptocom",
      "currencycom",
      "delta",
      "deribit",
      "digifinex",
      "eqonex",
      "exmo",
      "flowbtc",
      "fmfwio",
      "ftx",
      "ftxus",
      "gate",
      "gateio",
      "gemini",
      "hitbtc",
      "hitbtc3",
      "hollaex",
      "huobi",
      "huobijp",
      "huobipro",
      "idex",
      "independentreserve",
      "indodax",
      "itbit",
      "kraken",
      "kucoin",
      "kucoinfutures",
      "kuna",
      "latoken",
      "lbank",
      "lbank2",
      "liquid",
      "luno",
      "lykke",
      "mercado",
      "mexc",
      "mexc3",
      "ndax",
      "novadax",
      "oceanex",
      "okcoin",
      "okex",
      "okex5",
      "okx",
      "paymium",
      "phemex",
      "poloniex",
      "probit",
      "qtrade",
      "ripio",
      "stex",
      "therock",
      "tidebit",
      "tidex",
      "timex",
      "tokocrypto",
      "upbit",
      "wavesexchange",
      "wazirx",
      "whitebit",
      "woo",
      "yobit",
      "zaif",
      "zb",
      "zipmex",
      "zonda"
    ]

    all_exchanges
    |> Enum.each(fn x -> ExCcxt.fetch_currencies(x) |> save("currencies_#{x}") end)
  end
end
