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
    # {opts, _, _} =
    #   OptionParser.parse(args,
    #     aliases: [

    #     ],
    #     strict: []
    #   )

    path = Application.app_dir(:aws_runtime, "priv/templates")
    Mix.Generator.copy_template(Path.join(path, "makefile.eex"), "Makefile", [])
  end
end
