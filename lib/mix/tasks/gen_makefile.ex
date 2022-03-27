defmodule Mix.Tasks.Aws.Gen.Makefile do
  @moduledoc """
  Generate a Makefile for the AWS Lambda runtime.
  """

  use Mix.Task

  @shortdoc "Generate a Makefile for the project"

  def run(args \\ [])

  def run(["help"]) do
    """
    Generate a Makefile for the project.
    """
  end

  def run(_args) do
    # name =
    #   Mix.Project.config()
    #   |> Keyword.fetch!(:app)
    #   |> to_string

    # {opts, _, _} =
    #   OptionParser.parse(args,
    #     aliases: [

    #     ],
    #     strict: []
    #   )

    Mix.Generator.copy_template("lib/templates/makefile.eex", "Makefile", [])
  end
end
