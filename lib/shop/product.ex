defmodule Shop.Product do
  @moduledoc """
  Module that represents a Product struct
  """

  @typedoc """
  Type that represents Product struct with
  :code as string, :name as string and :price as money
  """
  @type t :: %__MODULE__{code: String.t(), name: String.t(), price: Money.t()}

  defstruct [:code, :name, :price]

  @doc """
  Returns a Product struct

  ## Parameters
  - code: String that represents the code of the product
  - name: String that represents the name of the product
  - price: Integer that represents the price of the product

  ## Examples
  iex> Shop.Product.new("VOUCHER", "Voucher", 5_00)

  %Shop.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :GBP}
  }
  """

  @spec new(String.t(), String.t(), integer()) :: __MODULE__.t()
  def new(code, name, price) do
    %__MODULE__{
      code: code,
      name: name,
      price: Money.new(price, :GBP)
    }
  end
end
