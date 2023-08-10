const std = @import("std");
const grpc = @import("c.zig");

test "grpc_import_test" {
    _ = grpc.GRPC_CALL_OK;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}
