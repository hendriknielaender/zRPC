ZIG ?= zig

update:
	git submodule update --init --recursive

build:
	$(ZIG) build -freference-trace

build-grpc:
	cd grpc && bazel --output_base=../grpc_build/ build :all

create-bindings:
	zig translate-c -I grpc/include grpc/include/grpc/grpc.h > src/grpc/grpc-bindings.zig

clean-grpc:
	rm grpc_build/CMakeCache.txt

build-exe:
	$(ZIG) build-exe src/main.zig -lc -Igrpc/include

init-export:
	export LDFLAGS="-L/usr/local/opt/zlib/lib"

