defmodule NxColor.MixProject do
  use Mix.Project

  @source_url "https://github.com/alisinabh/nx_color"
  @version "0.0.1-dev"

  def project do
    [
      app: :nx_color,
      version: @version,
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: "Colorspace conversions using Elixir Nx",
      package: package(),
      docs: docs(),
      deps: deps(),
      preferred_cli_env: [
        docs: :docs,
        "hex.publish": :docs
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Alisina Bahadori"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ex_doc, "~> 0.23", only: :docs},
      {:exla, "~> 0.2", only: :test},
      {:nx, "~> 0.2"}
    ]
  end

  defp docs do
    [
      main: "NxColor",
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end
end
