const std = @import("std");

const grpc = @cImport({
    @cInclude("grpc.h");
});

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}
