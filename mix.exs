defmodule AwsRuntime.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_runtime,
      version: "0.1.4",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      source_url: "https://github.com/NeoArcanjo/aws-lambda-runtime-boilerplate",
      name: "AWS Runtime"
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AwsRuntime.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description do
    "A few sentences (a paragraph) describing the project."
  end

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "aws_runtime",
      # These are the default files included in the package
      files: ~w(lib priv .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/NeoArcanjo/aws-lambda-runtime-boilerplate"}
    ]
  end

  defp aliases do
    [test: "test --no-start"]
  end
end
