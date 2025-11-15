# Installation Guide

This guide will help you install and configure ExCcxt in your Elixir project.

## Prerequisites

Before installing ExCcxt, ensure you have the following installed:

- **Elixir 1.10 or later**
- **Node.js 14 or later** (required for the JavaScript bridge)
- **npm or yarn** (for JavaScript dependencies)

You can verify your installations:

```bash
elixir --version
node --version
npm --version
```

## Installation

### 1. Add ExCcxt to your dependencies

Add ExCcxt to your `mix.exs` file:

```elixir
def deps do
  [
    {:ex_ccxt, "~> 0.1.0"}
  ]
end
```

### 2. Fetch dependencies

```bash
mix deps.get
```

### 3. Install JavaScript dependencies

ExCcxt requires the CCXT JavaScript library. Install it by running:

```bash
# Navigate to your project directory
cd your_project

# Install JavaScript dependencies (this will install CCXT)
mix deps.compile ex_ccxt
```

This will automatically:
- Download the CCXT JavaScript library
- Bundle the JavaScript code
- Place the bundled files in the correct location

## Configuration

### Basic Configuration

ExCcxt works out of the box with default settings. However, you can customize the configuration in your `config/config.exs`:

```elixir
config :ex_ccxt,
  pool_size: 16,  # Number of Node.js worker processes
  timeout: 30_000 # Timeout for JavaScript calls in milliseconds
```

### Application Setup

Make sure your application includes ExCcxt in the supervision tree. If you're using ExCcxt in a Phoenix application or another supervised application, this is usually handled automatically.

For a standalone application, ensure ExCcxt is started:

```elixir
# In your application.ex
def start(_type, _args) do
  children = [
    # Your other children
    ExCcxt.Application
  ]

  opts = [strategy: :one_for_one, name: YourApp.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Verification

To verify that ExCcxt is installed and working correctly, try fetching a list of available exchanges:

```elixir
# Start an interactive Elixir session
iex -S mix

# Test the installation
ExCcxt.exchanges()
```

You should see a list of supported exchanges like:

```elixir
{:ok, ["aax", "alpaca", "ascendex", "bequant", "bigone", "binance", ...]}
```

## Troubleshooting

### Common Issues

#### Node.js not found
If you get an error about Node.js not being found:

1. Ensure Node.js is installed and in your PATH
2. Restart your terminal/IDE after installing Node.js
3. Try running `node --version` to verify installation

#### JavaScript compilation errors
If you encounter errors during JavaScript compilation:

1. Ensure npm/yarn is installed
2. Try manually installing dependencies:
   ```bash
   cd deps/ex_ccxt
   npm install
   ```
3. Clear and recompile:
   ```bash
   mix deps.clean ex_ccxt
   mix deps.compile ex_ccxt
   ```

#### Port/Process errors
If you see errors related to ports or processes:

1. Check that the configured pool size isn't too large for your system
2. Reduce the pool size in configuration:
   ```elixir
   config :ex_ccxt, pool_size: 4
   ```

### Memory Considerations

Each Node.js worker process consumes memory. The default pool size of 16 workers should be fine for most applications, but you may want to adjust this based on:

- Your system's available memory
- Expected concurrent load
- Number of different exchanges you'll be calling simultaneously

### Performance Tips

- **Pool Size**: Increase pool size for high-concurrency applications
- **Timeout**: Adjust timeout based on network conditions and exchange response times
- **Caching**: Consider implementing caching for frequently requested data
- **Rate Limiting**: Be mindful of exchange rate limits and implement appropriate delays

## Development Setup

If you're contributing to ExCcxt or running it in development:

```bash
# Clone the repository
git clone https://github.com/your-repo/ex_ccxt.git
cd ex_ccxt

# Install Elixir dependencies
mix deps.get

# Build JavaScript bundle
./build_ex_ccxt_js.sh

# Run tests
mix test

# Start interactive session
iex -S mix
```

## Next Steps

- [Overview](overview.md) - Learn about ExCcxt's architecture and features
- [Public API Reference](public_api.md) - Explore available functions
- [Disclaimer](disclaimer.md) - Important usage considerations