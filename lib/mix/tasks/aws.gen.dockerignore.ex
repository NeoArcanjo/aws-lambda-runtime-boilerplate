defmodule Mix.Tasks.Aws.Gen.Dockerignore do
  @moduledoc """
  Generate a .dockerignore for the AWS Lambda runtime.
  """

  use Mix.Task

  @shortdoc "Generate a .dockerignore for the project"

  def run(args \\ [])

  def run(["help"]) do
    """
    Generate a .dockerignore for the project.
    """
  end

  def run(_args) do
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
