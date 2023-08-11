ZIG ?= zig

update:
	git submodule update

build:
	$(ZIG) build -freference-trace

build-grpc:
	cd grpc && make install prefix=../grpc_build

exe:
	$(ZIG) build-exe src/main.zig -lc -Igrpc/include

