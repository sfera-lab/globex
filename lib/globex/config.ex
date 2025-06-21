defmodule Globex.Config do
  @moduledoc ~S"""
  A Globex Config is used to define the default configuration for your application modules.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Globex.Config, only: [globex: 3]
      Module.register_attribute(__MODULE__, :configs, accumulate: true)
    end
  end

  defmacro globex(module_name, key, value) do
    module_name_string = Macro.to_string(module_name) |> String.replace(".", "_")
    function_name = String.to_atom("get_#{module_name_string}_#{key}")

    quote do
      configs = Module.get_attribute(__MODULE__, :configs)
      if {unquote(module_name_string), unquote(key)} in configs do
        raise "Config module:#{unquote(module_name_string)} key: #{unquote(key)} already defined"
      else
        Module.put_attribute(__MODULE__, :configs, {unquote(module_name_string), unquote(key)})

        def unquote(function_name)() do
          unquote(value)
        end
      end
    end
  end
end
