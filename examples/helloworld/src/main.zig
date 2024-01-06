const std = @import("std");
const grpc = @import("grpc/grpc-bindings.zig");
const helloworld = @import("proto/helloworld.pb.zig");

const Greeter = struct {
    allocator: *const std.mem.Allocator,

    pub fn sayHello(self: *Greeter, _: *const grpc.ServerCallContext, request: helloworld.HelloRequest) !helloworld.HelloReply {
        var response = helloworld.HelloReply{
            .message = try std.mem.dupe(self.allocator, u8, "Hello, " ++ request.name),
        };
        defer response.message.deinit();
        return response;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) std.debug.panic("Memory leak detected\n", .{});
    }

    const target = "localhost:50051";

    const creds = null; // Replace with actual credentials if needed
    const args = null; // Replace with actual channel arguments if needed

    const channel = grpc.grpc_channel_create(target, creds, args) orelse return error.FailedToCreateChannel;
    defer grpc.grpc_channel_destroy(channel); // Correct function to destroy the channel

    const reserved = null;

    const server = grpc.grpc_server_create(args, reserved) orelse return error.FailedToInitializeServer;
    defer grpc.grpc_server_destroy(server); // Replace with the correct function to clean up the server

    var greeter = Greeter{ .allocator = &allocator };
    defer greeter.deinit();

    try server.registerService(&greeter);
    try server.start();

    const stdout = std.io.getStdOut().writer();
    try stdout.print("gRPC server running on {s}\n", .{target});

    while (true) {
        try server.run();
    }
}
