const ccxt = require("ccxt")

// -------------- PUBLIC ----------------- //

async function fetchStatus(exchange, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchStatus(params)
}

async function fetchTrades({ exchange, base, quote, since }) {
  const symbolString = `${base}/${quote}`
  const sinceUnix = new Date(since).getTime()
  return await new ccxt[exchange].fetchTrades(symbolString, sinceUnix)
}

const exchanges = async () => ccxt.exchanges

async function fetchOhlcvs({exchange, base, quote, timeframe, since, limit }) {
  const symbol = `${base}/${quote}`
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOHLCV(symbol, timeframe, since, limit)
}

async function fetchTicker({exchange, symbol}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchTicker(symbol)
}

async function fetchTickers(exchange, symbols, params) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchTickers(symbols, params)
}

async function fetchTickersAll(exchange) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchTickers()
}

async function fetchMarkets(exchange) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchMarkets()
}

async function fetchMarketsForExchange(exchange_id) {
  const exchange = new ccxt[exchange_id]()
  return await exchange.loadMarkets()
}

async function fetchOrderBook({exchange, symbol, limit, params = {}}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOrderBook(symbol, limit, params)
}

async function fetchCurrencies(exchange) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchCurrencies()
}

async function loadMarkets(exchange, reload = false) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.loadMarkets(reload)
}

async function fetchL2OrderBook(exchange, symbol, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchL2OrderBook(symbol, limit, params)
}

async function fetchOpenInterest(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOpenInterest(symbol, params)
}

async function fetchVolatilityHistory(exchange, code, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchVolatilityHistory(code, params)
}

async function fetchUnderlyingAssets(exchange) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchUnderlyingAssets()
}

async function fetchSettlementHistory(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchSettlementHistory(symbol, since, limit, params)
}

async function fetchLiquidations(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchLiquidations(symbol, since, limit, params)
}

async function fetchGreeks(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchGreeks(symbol, params)
}

async function fetchAllGreeks(exchange, symbols, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchAllGreeks(symbols, params)
}

async function fetchOption(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOption(symbol, params)
}

async function fetchOptionChain(exchange, code, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOptionChain(code, params)
}

async function fetchConvertQuote(exchange, fromCode, toCode, amount, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchConvertQuote(fromCode, toCode, amount, params)
}

async function fetchFundingRate(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchFundingRate(symbol, params)
}

async function fetchFundingRates(exchange, symbols, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchFundingRates(symbols, params)
}

async function fetchFundingRateHistory(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchFundingRateHistory(symbol, since, limit, params)
}

async function fetchFundingRateInterval(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchFundingRateInterval(symbol, params)
}

async function fetchFundingRateIntervals(exchange, symbols, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchFundingRateIntervals(symbols, params)
}

async function fetchLongShortRatio(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchLongShortRatio(symbol, params)
}

async function requiredCredentials(exchange) {
  const _exchange = new ccxt[exchange]()
  return _exchange.requiredCredentials
}


// -------------- PRIVATE ----------------- //

async function fetchBalance(exchange, cred, params = {}) {
  const _exchange = new ccxt[exchange](cred)
  return await _exchange.fetchBalance(params)
}

async function createOrder(exchange, symbol, type, side, amount, price, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createOrder(symbol, type, side, amount, price, params)
}

async function createOrders(exchange, orders, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createOrders(orders, params)
}

async function createLimitBuyOrder(exchange, symbol, amount, price, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createLimitBuyOrder(symbol, amount, price, params)
}

async function createLimitSellOrder(exchange, symbol, amount, price, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createLimitSellOrder(symbol, amount, price, params)
}

async function createMarketBuyOrder(exchange, symbol, amount, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createMarketBuyOrder(symbol, amount, params)
}

async function createMarketSellOrder(exchange, symbol, amount, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createMarketSellOrder(symbol, amount, params)
}

async function cancelOrder(exchange, id, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.cancelOrder(id, symbol, params)
}

async function fetchOrder(exchange, id, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOrder(id, symbol, params)
}

async function fetchOrders(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOrders(symbol, since, limit, params)
}

async function fetchOpenOrders(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOpenOrders(symbol, since, limit, params)
}

async function fetchCanceledOrders(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchCanceledOrders(symbol, since, limit, params)
}

async function fetchClosedOrders(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchClosedOrders(symbol, since, limit, params)
}

async function fetchMyTrades(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchMyTrades(symbol, since, limit, params)
}

async function fetchMyLiquidations(exchange, symbol, since, limit, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchMyLiquidations(symbol, since, limit, params)
}

async function fetchCrossBorrowRate(exchange, code, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchCrossBorrowRate(code, params)
}

async function fetchCrossBorrowRates(exchange, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchCrossBorrowRates(params)
}

async function fetchIsolatedBorrowRate(exchange, symbol, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchIsolatedBorrowRate(symbol, params)
}

async function fetchIsolatedBorrowRates(exchange, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchIsolatedBorrowRates(params)
}

async function createConvertTrade(exchange, id, fromCode, toCode, amount, params = {}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.createConvertTrade(id, fromCode, toCode, amount, params)
}

// -------------- EXPORT ----------------- //

module.exports = {
  // Public API functions
  fetchTrades,
  exchanges,
  fetchMarketsForExchange,
  fetchOhlcvs,
  fetchTicker,
  fetchTickers,
  fetchTickersAll,
  fetchMarkets,
  fetchOrderBook,
  fetchCurrencies,
  loadMarkets,
  fetchStatus,
  fetchL2OrderBook,
  fetchOpenInterest,
  fetchVolatilityHistory,
  fetchUnderlyingAssets,
  fetchSettlementHistory,
  fetchLiquidations,
  fetchGreeks,
  fetchAllGreeks,
  fetchOption,
  fetchOptionChain,
  fetchConvertQuote,
  fetchFundingRate,
  fetchFundingRates,
  fetchFundingRateHistory,
  fetchFundingRateInterval,
  fetchFundingRateIntervals,
  fetchLongShortRatio,
  requiredCredentials,

  // Private API functions (require authentication)
  fetchBalance,
  createOrder,
  createOrders,
  createLimitBuyOrder,
  createLimitSellOrder,
  createMarketBuyOrder,
  createMarketSellOrder,
  cancelOrder,
  fetchOrder,
  fetchOrders,
  fetchOpenOrders,
  fetchCanceledOrders,
  fetchClosedOrders,
  fetchMyTrades,
  fetchMyLiquidations,
  fetchCrossBorrowRate,
  fetchCrossBorrowRates,
  fetchIsolatedBorrowRate,
  fetchIsolatedBorrowRates,
  createConvertTrade
}
