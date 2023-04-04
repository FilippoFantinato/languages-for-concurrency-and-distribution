defmodule FactServerTest do
  use ExUnit.Case
  doctest FactServer

  test "greets the world" do
    assert FactServer.hello() == :world
  end
end
