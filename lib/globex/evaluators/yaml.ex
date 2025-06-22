defmodule Globex.Evaluators.Yaml do
  @moduledoc """
  YAML evaluator.
  """

  @doc """
  Evaluate a YAML file.
  """
  def evaluate(file) do
    YamlElixir.read_from_file(file, atoms: true)
  end
end
