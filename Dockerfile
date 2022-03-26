FROM elixirbase:latest

ENV MIX_ENV=dev

COPY . /aws_runtime
WORKDIR /aws_runtime

RUN mix deps.get
RUN mix compile
CMD mix app.start
