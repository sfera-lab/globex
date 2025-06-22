defmodule Globex.Evaluators.YamlTest do
  use ExUnit.Case

  test "evaluate" do
    assert Globex.Evaluators.Yaml.evaluate("test/support/test.yaml") ==
             {:ok,
              %{
                "Test" => %{"test_key" => "test_value", "created_at" => "2025-06-21"}
              }}
  end
end
