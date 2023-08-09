ZIG ?= zig

update:
	git submodule update

build:
	$(ZIG) build -freference-trace

