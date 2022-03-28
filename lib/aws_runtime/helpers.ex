defmodule AwsRuntime.Helpers do
  def get_name,
    do:
      Mix.Project.config()
      |> Keyword.fetch!(:app)
      |> to_string
end
