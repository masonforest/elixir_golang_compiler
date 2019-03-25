# GolangCompiler

A [golang](https://golang.org/) compiler for Elixir's `mix`. Allows users to
write elixir [ports](https://hexdocs.pm/elixir/Port.html) in golang. Building
nifs is not currently supported. Most of the code for this project was copied
from the excellent [rustler](https://github.com/rusterlium/rustler) crate.
Thanks [@hansihe](https://github.com/hansihe) and team!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `golang_compiler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:golang_compiler, "~> 0.1.0"}
  ]
end
```

## Setup

Add the following to your mix.exs

  def project do
    [
      ...
      compilers: [:golang] ++ Mix.compilers(),
      golang_modules: golang_modules(),
      ...
    ]
  end


  defp golang_modules do
    [
      my_go_port: [
        path: "native/my_go_port",
      ]
    ]
  end

This will build whatever is in `native/my_go_port` and copy the resulting binary
to the `priv` directory
