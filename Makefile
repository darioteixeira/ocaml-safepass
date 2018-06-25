.PHONY: all
all:
	jbuilder build --dev

.PHONY: clean
clean:
	jbuilder clean

.PHONY: doc
doc:
	jbuilder build @doc
