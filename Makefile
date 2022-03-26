CMD?=
WD?=

PROJECTFILES=$(shell ls -1 *.ex{s,}) $(shell find lib src test -type f)
.PHONY: run base bind

base: .make/base
build: .make/build

run: .make/build
  docker run -it erlambda $(CMD)

bind: .make/base
  docker run -it --mount type=bind,source=$(shell pwd),target=/bind elixirbase sh -ec "cd /bind/$(WD); $(CMD)"

.make/build: .make/base Dockerfile $(PROJECTFILES)
  docker build -t erlambda .
  date > .make/build

.make/base: .make images/base.Dockerfile
  docker build -t elixirbase -f $(shell pwd)/images/base.Dockerfile .
  date > .make/base

.make:
  mkdir -p .make
