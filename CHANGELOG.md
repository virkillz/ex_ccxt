# Changelog

## [Unreleased]

### Added
- Comprehensive @moduledoc documentation for all modules in lib/ directory
- Complete @doc documentation for all public and private API functions
- Detailed parameter descriptions and usage examples for all functions
- Type specifications for improved code documentation and IDE support

### Changed
- Enhanced ExCcxt.Application moduledoc with supervision tree details
- Improved main ExCcxt moduledoc with better formatting and clarity

### Fixed
- Fixed typo in main ExCcxt moduledoc ("try" → "tries")
- Removed stray ":DSS" text from moduledoc

### Documentation
- Added detailed documentation for OHLCV and candlestick data functions
- Added comprehensive docs for options trading functions (fetch_greeks, fetch_option, etc.)
- Added detailed docs for futures trading functions (fetch_funding_rate, fetch_settlement_history, etc.)
- Added complete documentation for private API functions (create_order, fetch_balance, etc.)
- Added moduledocs for all struct modules (Ticker, Market, OrderBook, Currency, etc.)
- Added documentation for utility modules (Utils, Helper, OhlcvOpts, Credential)
- Enhanced documentation includes practical examples and important usage notes
