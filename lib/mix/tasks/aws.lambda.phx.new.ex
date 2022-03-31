defmodule Mix.Tasks.Aws.Lambda.Phx.New do
  @moduledoc """
  Generate a Makefile for the AWS Lambda runtime.
  """

  use Mix.Task

  @shortdoc "Generate a Phoenix project"

  def run([]) do
    Mix.shell().info("Like mix phx.new, but for AWS Lambda.")
  end

  def run(["help"]) do
    """
    Generate a Makefile for the project.
    """
  end

  def run([name | opts]) do
    Mix.shell().cmd("mix phx.new #{name} #{opts}")

    File.cd!(name) |> IO.inspect()

    Mix.Tasks.Aws.Gen.Dockerfile.run(["--name", name])
    Mix.Tasks.Aws.Gen.Makefile.run(["--name", name])

    Mix.Generator.create_directory("src")
    Mix.Tasks.Aws.Gen.Dockerignore.run([])
  end
end
