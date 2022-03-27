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
        strict: [elixir: :string, erlang: :string, name: :string]
      )

    iex_version = Keyword.get(opts, :elixir, "1.13.1")
    erl_version = Keyword.get(opts, :erlang, "24.3.2")
    name = Keyword.get(opts, :name) || get_name()

    path = Application.app_dir(:aws_runtime, "priv/templates")
    Mix.Generator.copy_template(Path.join(path, "dockerfile.eex"), "Dockerfile", app: name)

    Mix.Generator.copy_template(
      Path.join(path, "cache.dockerfile.eex"),
      "images/cache.Dockerfile",
      app: name
    )

    Mix.Generator.copy_template(Path.join(path, "base.dockerfile.eex"), "images/base.Dockerfile",
      elixir_version: iex_version,
      otp_version: erl_version
    )
  end

  defp get_name,
    do:
      Mix.Project.config()
      |> Keyword.fetch!(:app)
      |> to_string
end
