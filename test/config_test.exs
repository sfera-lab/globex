defmodule Globex.ConfigTest do
  use ExUnit.Case
  doctest Globex.Config

  defmodule TestConfig do
    use Globex.Config

    globex(Database, :host, "localhost")
    globex(Database, :port, 5432)
    globex(Api, :timeout, 5000)
    globex(Api, :retries, 3)
  end

  describe "globex macro" do
    test "generates functions with correct names" do
      assert function_exported?(TestConfig, :get_Database_host, 0)
      assert function_exported?(TestConfig, :get_Database_port, 0)
      assert function_exported?(TestConfig, :get_Api_timeout, 0)
      assert function_exported?(TestConfig, :get_Api_retries, 0)
    end

    test "returns correct values" do
      assert TestConfig.get_Database_host() == "localhost"
      assert TestConfig.get_Database_port() == 5432
      assert TestConfig.get_Api_timeout() == 5000
      assert TestConfig.get_Api_retries() == 3
    end

    test "handles different data types" do
      assert is_binary(TestConfig.get_Database_host())
      assert is_integer(TestConfig.get_Database_port())
      assert is_integer(TestConfig.get_Api_timeout())
      assert is_integer(TestConfig.get_Api_retries())
    end

    test "function names are properly formatted" do
      # Test that the function names follow the expected pattern
      assert TestConfig.get_Database_host() == "localhost"
      assert TestConfig.get_Database_port() == 5432
    end
  end

  describe "duplicate config handling" do
    test "raises error for duplicate module:key combinations" do
      assert_raise RuntimeError, ~r/Config module:Test key: value already defined/, fn ->
        code = """
        defmodule DuplicateTest do
          use Globex.Config
          globex Test, :value, "first"
          globex Test, :value, "second"
        end
        """

        Code.compile_string(code)
      end
    end
  end

  describe "macro expansion" do
    test "creates proper function definitions" do
      assert TestConfig.get_Database_host() == "localhost"
      assert TestConfig.get_Database_port() == 5432
    end

    test "handles complex module names" do
      defmodule ComplexModuleName do
        use Globex.Config
        globex(MyApp.Database, :connection_string, "postgres://localhost/db")
      end

      assert ComplexModuleName.get_MyApp_Database_connection_string() == "postgres://localhost/db"
    end
  end

  describe "edge cases" do
    test "handles empty strings and nil values" do
      defmodule EdgeCaseConfig do
        use Globex.Config
        globex(Empty, :string, "")
        globex(Nil, :value, nil)
      end

      assert EdgeCaseConfig.get_Empty_string() == ""
      assert EdgeCaseConfig.get_Nil_value() == nil
    end

    test "handles atoms and other data types" do
      defmodule DataTypeConfig do
        use Globex.Config
        globex(Atom, :value, :ok)
        globex(List, :value, [1, 2, 3])
        globex(Map, :value, %{key: "value"})
      end

      assert DataTypeConfig.get_Atom_value() == :ok
      assert DataTypeConfig.get_List_value() == [1, 2, 3]
      assert DataTypeConfig.get_Map_value() == %{key: "value"}
    end
  end

  describe "module attributes" do
    test "accumulates configs in module attribute" do
      assert TestConfig.get_Database_host() == "localhost"
      assert TestConfig.get_Database_port() == 5432
    end
  end
end
