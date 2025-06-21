defmodule Globex.MixProject do
  use Mix.Project

  def project do
    [
      app: :globex,
      version: "0.0.1",
      elixir: "~> 1.18",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      test_coverage: [tool: ExCoveralls],
      package: package(),
      deps: deps(),
      name: "Globex",
      source_url: "https://github.com/sfera-lab/globex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Globex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18.3", only: :test}
    ]
  end

  defp description do
    "Global variable library for Elixir."
  end

  defp package do
    [
      name: "globex",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sfera-lab/globex"}
    ]
  end
end
