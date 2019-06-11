defmodule GolangCompiler.MixProject do
  use Mix.Project

  def project do
    [
      app: :golang_compiler,
      description: "Golang complier for mix",
      metadata: [
      ],
      version: "0.2.1",
      elixir: "~> 1.8",
      deps: deps(),
      package: package(),
    ]
  end

  def application do
    []
  end

  def deps() do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
  def package do
    [
      maintainers: ["Mason Fischer"],
      licenses: ["MIT", "Apache-2.0"],
      links: %{"GitHub" => "https://github.com/masonforest/elixir_golang_compiler"}
    ]
  end
end
