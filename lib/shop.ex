defmodule Shop do
  @moduledoc """
  Module that implements Shop's public interface
  """

  alias Shop.Product
  alias Shop.ProductServer
  alias Shop.RuleServer

  @doc """
  Adds a rule to the checkout process

  ## Parameters
  - rule: A Rule module that implements Rules' Behavior

  ## Examples
  iex> Shop.add_rule(Shop.Rules.MarketingRule)

  {:ok, Shop.Rules.MarketingRule}
  """
  @spec add_rule(module()) :: {:ok, module()}
  def add_rule(rule) do
    {RuleServer.add(&rule.apply/1), rule}
  end

  @doc """
  Scans a product

  ## Parameters
  - product: A Product struct

  ## Examples
  iex> voucher = Shop.Product.new("VOUCHER", "Voucher", 5_00)

  %Shop.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :GBP}
  }

  iex> Shop.scan(voucher)

  {:ok, %Shop.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :GBP}
  }}
  """
  @spec scan(Product.t()) :: {:ok, Product.t()}
  def scan(product) do
    {ProductServer.add(product), product}
  end

  @doc "Applies rules and calculates final price"
  @spec total() :: String.t()
  def total do
    products = ProductServer.all()
    rules = RuleServer.all()

    rules_result =
      Enum.map(rules, fn rule ->
        rule.(products)
      end)

    total =
      Enum.reduce(products, Money.new(0, :GBP), fn p, acc ->
        Money.add(acc, p.price)
      end)

    final_price =
      Enum.reduce(rules_result, total, fn r, acc ->
        acc
        |> Money.add(r.add)
        |> Money.subtract(r.sub)
      end)

    final_price
    |> Money.to_string(
      separator: ",",
      delimeter: ".",
      symbol: true
    )
  end
end
