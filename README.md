# Globex

A global variable library for Elixir that provides a simple way to manage global state in your applications.

[![Coverage Status](https://coveralls.io/repos/github/sfera-lab/globex/badge.svg?branch=main)](https://coveralls.io/github/sfera-lab/globex?branch=main)

## Installation

```elixir
def deps do
  [
    {:globex, "~> 0.0.1"}
  ]
end
```

## Usage

Globex provides a simple way to define and access global configuration values in your Elixir applications. It uses macros to generate functions that return your configured values.

### Basic Configuration

First, create a configuration module:

```elixir
defmodule MyApp.Config do
  use Globex.Config

  # Define configuration values
  globex(Database, :host, "localhost")
  globex(Database, :port, 5432)
  globex(Api, :timeout, 5000)
  globex(Api, :retries, 3)
end
```

Then use the generated functions:

```elixir
# Access your configuration values
MyApp.Config.get_Database_host()    # Returns "localhost"
MyApp.Config.get_Database_port()    # Returns 5432
MyApp.Config.get_Api_timeout()      # Returns 5000
MyApp.Config.get_Api_retries()      # Returns 3
```

### External Configuration with YAML

Globex supports loading configuration from external YAML files, which can override the default values:

```yaml
# config.yaml
Database:
  host: "production-db.example.com"
  port: 5432
Api:
  timeout: 10000
  retries: 5
```

```elixir
defmodule MyApp.Config do
  use Globex.Config

  # Load external configuration
  globex_path("config.yaml")

  # Define default values (will be overridden by YAML if present)
  globex(Database, :host, "localhost")
  globex(Database, :port, 5432)
  globex(Api, :timeout, 5000)
  globex(Api, :retries, 3)
end
```

In this case, the YAML values will take precedence over the default values defined in the module.

### Function Naming Convention

Globex generates function names following this pattern:
- `get_<ModuleName>_<key>()`
- Module names with dots are converted to underscores
- Keys are converted to atoms

Examples:
- `globex(Database, :host, "localhost")` → `get_Database_host()`
- `globex(MyApp.Database, :connection_string, "...")` → `get_MyApp_Database_connection_string()`

### Supported Data Types

Globex supports all Elixir data types:

```elixir
defmodule DataTypes do
  use Globex.Config

  globex(String, :value, "hello")
  globex(Integer, :value, 42)
  globex(Float, :value, 3.14)
  globex(Atom, :value, :ok)
  globex(List, :value, [1, 2, 3])
  globex(Map, :value, %{key: "value"})
  globex(Boolean, :value, true)
  globex(Nil, :value, nil)
end
```

### Error Handling

- **Invalid YAML files**: If a YAML file cannot be parsed, Globex will raise an error during compilation
- **Unsupported file types**: Only `.yaml` and `.yml` files are supported
- **Missing external configs**: If a key is not found in the external configuration, the default value will be used

### Best Practices

1. **Organize by module**: Group related configuration under meaningful module names
2. **Use descriptive keys**: Choose clear, descriptive key names
3. **Provide sensible defaults**: Always provide default values in your code
4. **Environment-specific configs**: Use different YAML files for different environments

```elixir
defmodule MyApp.Config do
  use Globex.Config

  # Load environment-specific configuration
  globex_path("config/#{Mix.env()}.yaml")

  # Sensible defaults
  globex(Database, :host, "localhost")
  globex(Database, :port, 5432)
  globex(Database, :pool_size, 10)
end
```

### Compile-time Resolution

All configuration is resolved at compile time, which means:
- No runtime overhead for accessing configuration values
- Configuration errors are caught during compilation
- Generated functions are optimized for performance

## Documentation

[Documentation available on HexDocs](https://hexdocs.pm/globex)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.