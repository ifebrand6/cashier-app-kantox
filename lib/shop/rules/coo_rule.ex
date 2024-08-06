defmodule Shop.Rules.COORule do
  @moduledoc """
  Module that implements C0O's Rule

  The COO, though, likes low prices and wants people buying strawberries to get a price
  discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
  per strawberry
  """

  alias Shop.Rules.RuleBehavior

  @behaviour RuleBehavior

  @doc """
  Implements COO's rule and returns either amount to add or amount to subtract

  ## Parameters
  - products: A Products list

  ## Examples
  iex> voucher = Shop.Product.new("VOUCHER", "Voucher", 5_00)

  %Shop.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :GBP}
  }

  iex> Shop.Rules.CFORule.apply([voucher])

  %{
    sub: %Money{amount: 0, currency: :GBP},
    add: %Money{amount: 0, currency: :GBP}
   }
  """
  @spec apply([Product.t()]) :: %{sub: Money.t(), add: Money.t()}
  def apply(products) do
    bulk_limit = 3
    discount = %Money{amount: 0_50, currency: :GBP}

    init = %{
      sub: %Money{amount: 0, currency: :GBP},
      add: %Money{amount: 0, currency: :GBP}
    }

    total_strawberries =
      products
      |> Stream.filter(fn p -> p.code === "SR1" end)
      |> Enum.count()

    if total_strawberries >= bulk_limit do
      Enum.reduce(1..total_strawberries, init, fn _, acc ->
        %{acc | sub: Money.add(acc.sub, discount)}
      end)
    else
      init
    end
  end
end
