defmodule AwsRuntimeTest do
  use ExUnit.Case
  doctest AwsRuntime

  test "greets the world" do
    assert AwsRuntime.hello() == :world
  end
end
