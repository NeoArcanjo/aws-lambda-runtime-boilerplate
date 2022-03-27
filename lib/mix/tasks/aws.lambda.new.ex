defmodule Mix.Tasks.Aws.Lambda.New do
  @moduledoc """
  Generate a Makefile for the AWS Lambda runtime.
  """

  use Mix.Task

  @shortdoc "Generate a Makefile for the project"

  def run([]) do
    Mix.shell().info("Like mix new, but for AWS Lambda.")
  end

  def run(["help"]) do
    """
    Generate a Makefile for the project.
    """
  end

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [n: :name],
        strict: [name: :string, sup: :boolean]
      )

    name = Keyword.get(opts, :name, "lambda")
    sup = Keyword.get(opts, :sup, false)

    Mix.Tasks.Aws.Gen.Dockerfile.run(["--name", name])
    Mix.Tasks.Aws.Gen.Makefile.run([])

    if sup do
      Mix.shell().cmd("make bind CMD=\"mix new #{name} --sup\"")
    else
      Mix.shell().cmd("make bind CMD=\"mix new #{name}\"")
    end

    Mix.shell().cmd("cp -rv #{name}/* #{name}/.* .")
    Mix.shell().cmd("rm -rf #{name}")
    Mix.Tasks.Aws.Gen.Dockerignore.run([])
  end
end
