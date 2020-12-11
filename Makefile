.PHONY: all build test clean

all: build

build:
	dune build

doc:
	dune build @doc

clean:
	dune clean
