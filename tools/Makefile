SCRIPT := ./fzf2sk.fish

.PHONY: all lint format

all: lint format

lint:
	@fish --no-execute $(SCRIPT)

format:
	@fish_indent --write $(SCRIPT)
