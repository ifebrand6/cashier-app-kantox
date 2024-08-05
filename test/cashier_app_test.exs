defmodule CashierAppTest do
  use ExUnit.Case
  doctest CashierApp

  test "greets the world" do
    assert CashierApp.hello() == :world
  end
end
