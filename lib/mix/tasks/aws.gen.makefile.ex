defmodule Mix.Tasks.Aws.Gen.Makefile do
  @moduledoc """
  Generate a Makefile for the AWS Lambda runtime.
  """

  use Mix.Task
  import AwsRuntime.Helpers

  @shortdoc "Generate a Makefile for the project"

  def run(args \\ [])

  def run(["help"]) do
    """
    Generate a Makefile for the project.
    """
  end

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [
          n: :name
        ],
        strict: [name: :string]
      )

    name = Keyword.get(opts, :name) || get_name()

    path = Application.app_dir(:aws_runtime, "priv/templates")
    Mix.Generator.copy_template(Path.join(path, "makefile.eex"), "Makefile", app: name)
  end
end
