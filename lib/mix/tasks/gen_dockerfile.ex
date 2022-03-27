defmodule Mix.Tasks.Aws.Gen.Dockerfile do
  @moduledoc """
  Generate a Dockerfile for the AWS Lambda runtime.
  """

  use Mix.Task

  @shortdoc "Generate a Dockerfile for the project"

  def run(args \\ [])

  def run(["help"]) do
    """
    Generate a Dockerfile for the project.
    """
  end

  def run(args) do
    name =
      Mix.Project.config()
      |> Keyword.fetch!(:app)
      |> to_string

    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [
          iex: :elixir,
          iex_version: :elixir,
          elixir_version: :elixir,
          erl: :erlang,
          erl_version: :erlang,
          erlang_version: :erlang
        ],
        strict: [elixir: :string, erlang: :string]
      )

    iex_version = Keyword.get(opts, :elixir, "1.13.1")
    erl_version = Keyword.get(opts, :erlang, "24.3.2")

    Mix.Generator.copy_template("lib/templates/dockerfile.eex", "Dockerfile", app: name)

    Mix.Generator.copy_template("lib/templates/base_dockerfile.eex", "images/base.Dockerfile",
      elixir_version: iex_version,
      otp_version: erl_version
    )

    Mix.Generator.copy_file(".gitignore", ".dockerignore")
    File.write!(".dockerignore", dockerignore(), [:append])
  end

  defp dockerignore do
    """
    /.make/
    /images/
    Dockerfile
    .dockerignore
    .gitignore
    Makefile
    README.md

    # IntelliJ files
    /.idea/
    \*.iml
    """
  end
end
