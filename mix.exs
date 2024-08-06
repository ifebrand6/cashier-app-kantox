defmodule Shop.MixProject do
  use Mix.Project

  def project do
    [
      app: :cashier_app,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Shop.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:money, "~> 1.2.1"},
      {:dialyxir, "~> 0.4", only: [:dev]}
    ]
  end
end
