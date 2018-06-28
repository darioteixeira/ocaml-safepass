.PHONY: all build test clean

all: build

build:
	jbuilder build

doc:
	jbuilder build @doc

clean:
	jbuilder clean
