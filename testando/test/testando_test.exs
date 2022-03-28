defmodule TestandoTest do
  use ExUnit.Case
  doctest Testando

  test "greets the world" do
    assert Testando.hello() == :world
  end
end
