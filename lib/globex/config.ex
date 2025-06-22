defmodule Globex.Config do
  @moduledoc ~S"""
  A Globex Config is used to define the default configuration for your application modules.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Globex.Config, only: [globex_path: 1, globex: 3]

      Module.register_attribute(__MODULE__, :configs, accumulate: true)
      Module.register_attribute(__MODULE__, :external_configs, accumulate: false)
    end
  end

  defmacro globex(module_name, key, value) do
    module_name_string = Macro.to_string(module_name) |> String.replace(".", "_")
    function_name = String.to_atom("get_#{module_name_string}_#{key}")
    external_configs = Module.get_attribute(__CALLER__.module, :external_configs) || %{}
    external_value = get_in(external_configs, [module_name_string, key])

    # Check for duplicate configurations
    existing_configs = Module.get_attribute(__CALLER__.module, :configs) || []

    # Check if this module:key combination already exists
    duplicate_exists = Enum.any?(existing_configs, fn {existing_module, existing_key, _existing_value} ->
      existing_module == module_name_string && existing_key == key
    end)

    if duplicate_exists do
      raise RuntimeError, "Config module:#{module_name_string} key: #{key} already defined"
    end

    quote do
      # Store the configuration
      @configs {unquote(module_name_string), unquote(key), unquote(value)}

      def unquote(function_name)() do
        case unquote(Macro.escape(external_value)) do
          nil -> unquote(value)
          external -> external
        end
      end
    end
  end

  defmacro globex_path(path) do
    if String.ends_with?(path, [".yaml", ".yml"]) do
      case Globex.Evaluators.Yaml.evaluate(path) do
        {:ok, configs} ->
          Module.put_attribute(__CALLER__.module, :external_configs, configs)

        {:error, error} ->
          raise "Error evaluating #{path}: #{error}"
      end
    else
      raise "Invalid path: #{path}. Only YAML files are supported."
    end
  end
end
