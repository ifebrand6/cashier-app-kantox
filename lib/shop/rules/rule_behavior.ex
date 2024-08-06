defmodule Shop.Rules.RuleBehavior do
  @moduledoc """
  Module that implements Rules' Behavior
  """

  alias Shop.Product

  @callback apply([Product.t()]) :: %{sub: Money.t(), add: Money.t()}
end
