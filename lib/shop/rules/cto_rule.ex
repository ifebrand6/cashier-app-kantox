defmodule Shop.Rules.CTORule do
  @moduledoc """
  Module that implements CTO's Rule

  The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop
  to two thirds of the original price.
  """

  alias Shop.Rules.RuleBehavior

  @behaviour RuleBehavior

  @doc """
  Implements CTO's rule and returns either amount to add or amount to subtract

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
    original_price = get_price(products, "CF1")

    discount_ratio = original_price.amount * 2 / 3
    amount = trunc(original_price.amount - discount_ratio)
    discount = %Money{amount: amount, currency: :GBP}

    init = %{
      sub: %Money{amount: 0, currency: :GBP},
      add: %Money{amount: 0, currency: :GBP}
    }

    total_strawberries =
      products
      |> Stream.filter(fn p -> p.code === "CF1" end)
      |> Enum.count()

    if total_strawberries >= bulk_limit do
      Enum.reduce(1..total_strawberries, init, fn _, acc ->
        %{acc | sub: Money.add(acc.sub, discount)}
      end)
    else
      init
    end
  end

  def get_price(products, code) do
    products
    |> Enum.find_value(fn p -> if p.code === code, do: p.price end)
  end
end
