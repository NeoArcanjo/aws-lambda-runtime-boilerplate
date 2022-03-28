FROM elixirbase:latest

ENV MIX_ENV=dev

COPY . /testando
WORKDIR /testando

RUN mix deps.get
RUN mix compile
