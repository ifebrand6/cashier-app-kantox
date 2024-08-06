defmodule Shop.Rules.CEORule do
  @moduledoc """
  Module that implements CEO's Rule

  The CEO is a big fan of buy-one-get-one-free offers and of green tea.
  """

  alias Shop.Product
  alias Shop.Rules.RuleBehavior

  @behaviour RuleBehavior

  @doc """
  Implements CEO's rule and returns either amount to add or amount to subtract

  ## Parameters
  - products: A Products list

  ## Examples
  iex> voucher = Shop.Product.new("VOUCHER", "Voucher", 5_00)

  %Shop.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :GBP}
  }

  iex> Shop.Rules.MarketingRule.apply([voucher])

  %{
    sub: %Money{amount: 0, currency: :GBP},
    add: %Money{amount: 0, currency: :GBP}
   }
  """
  @spec apply([Product.t()]) :: %{sub: Money.t(), add: Money.t()}
  def apply(products) do
    init = %{
      items: 0,
      sub: %Money{amount: 0, currency: :GBP},
      add: %Money{amount: 0, currency: :GBP}
    }

    result =
      products
      |> Stream.filter(fn p -> p.code === "GR1" end)
      |> Enum.reduce(init, fn p, acc ->
        cond do
          rem(acc.items, 2) == 1 ->
            %{acc | items: acc.items + 1, sub: Money.add(acc.sub, p.price)}

          true ->
            %{acc | items: acc.items + 1}
        end
      end)

    %{
      sub: result.sub,
      add: result.add
    }
  end
end
