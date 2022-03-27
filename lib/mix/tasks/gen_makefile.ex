defmodule Mix.Tasks.Aws.Gen.Makefile do
  @moduledoc """
  Generate a Makefile for the AWS Lambda runtime.
  """

  use Mix.Task
  import Mix.Generator

  embed_text(
    :makefile,
    """
    CMD?=
    WD?=

    PROJECTFILES=$(shell ls -1 *.ex{s,}) $(shell find lib src test -type f)
    .PHONY: run base bind

    base: .make/base
    build: .make/build

    run: .make/build
    \tdocker run -it erlambda $(CMD)

    bind: .make/base
    \tdocker run -it --mount type=bind,source=$(shell pwd),target=/bind elixirbase sh -ec "cd /bind/$(WD); $(CMD)"

    .make/build: .make/base Dockerfile $(PROJECTFILES)
    \tdocker build -t erlambda .
    \tdate > .make/build

    .make/base: .make images/base.Dockerfile
    \tdocker build -t elixirbase -f $(shell pwd)/images/base.Dockerfile .
    \tdate > .make/base

    .make:
    \tmkdir -p .make
    """
  )

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

    Mix.Generator.copy_template(makefile_text(), "Makefile.1", [])
	Mix.Generator.copy_template("templates/makefile.eex", "Makefile.2", [])
    Mix.Generator.create_file(
      "Makefile",
      makefile_text()
    )
  end
end
