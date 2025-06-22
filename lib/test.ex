defmodule Test do
  use Globex.Config

  globex_path("test/support/test.yaml")

  globex(Hello, :world, "Hello, world!")
  globex(Hello, :world, "Hello, world")
end
