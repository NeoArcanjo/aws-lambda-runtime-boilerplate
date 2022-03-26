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
    # todo: obter do cli a elixir version e erlang version
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

    Mix.Generator.create_file(
      "Dockerfile",
      dockerfile_template(:app, name)
    )

    Mix.Generator.create_file(
      "images/base.Dockerfile",
      dockerfile_template(:base, iex_version, erl_version)
    )

    System.cmd("cat", ["./.gitignore"])
    |> IO.inspect()

    IO.inspect(1)
  end

  defp dockerfile_template(:base, iex_version, erl_version) do
    """
    FROM public.ecr.aws/amazonlinux/amazonlinux:latest as root

    RUN yum install deltarpm -y
    RUN yum update -y
    RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
    RUN yum install ncurses-libs openssl-libs flex java-1.8.0-openjdk libxslt fop -y

    ENV LANG=c.UTF-8
    ENV LC_COLLATE="en_US.UTF-8"
    ENV LC_CTYPE="en_US.UTF-8"
    ENV LC_MESSAGES="en_US.UTF-8"
    ENV LC_MONETARY="en_US.UTF-8"
    ENV LC_NUMERIC="en_US.UTF-8"
    ENV LC_TIME="en_US.UTF-8"
    ENV LC_ALL="en_US.UTF-8"
    ENV ELIXIR_VERSION="v#{iex_version}"
    ENV OTP_VERSION="OTP-#{erl_version}"

    FROM root as buildelixir

    RUN yum install git perl ncurses-devel openssl-devel flex-devel java-1.8.0-openjdk-devel libxslt-devel sed -y
    RUN yum groupinstall "Development Tools" -y
    RUN git clone https://github.com/erlang/otp.git erlang
    RUN git clone https://github.com/elixir-lang/elixir.git

    ENV ERL_TOP=/erlang
    WORKDIR /erlang
    RUN git checkout $OTP_VERSION
    RUN ./configure --prefix=/opt/erlang
    RUN make
    RUN make release_tests
    WORKDIR /erlang/release/tests/test_server
    RUN /erlang/bin/erl -s ts install -s ts smoke_test batch -s init stop
    WORKDIR /erlang
    RUN make install

    ENV PATH="$PATH:/opt/erlang/bin:/opt/erlang/lib"
    WORKDIR /elixir
    RUN git checkout ${ELIXIR_VERSION}
    RUN make clean test
    RUN make install PREFIX=/opt/elixir

    FROM root

    COPY --from=buildelixir /opt/erlang /opt/erlang
    COPY --from=buildelixir /opt/elixir /opt/elixir
    ENV PATH="$PATH:/opt/erlang/bin:/opt/erlang/lib:/opt/elixir/bin:/opt/elixir/lib"
    RUN mix local.hex --force
    RUN epmd -daemon
    """
  end

  defp dockerfile_template(:app, app) do
    """
    FROM elixirbase:latest

    ENV MIX_ENV=dev

    COPY . /#{app}
    WORKDIR /#{app}

    RUN mix deps.get
    RUN mix compile
    CMD mix app.start
    """
  end
end
