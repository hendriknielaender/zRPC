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

    const method_name = "Greeter/SayHello"; // Replace with the correct method name as per your .proto file

    // Additional parameters required by grpc_server_register_method
    const host = null; // or specify a host if necessary
    const payload_handling = grpc.GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER; // or another appropriate value
    const flags = 0; // use appropriate flags

    const method = grpc.grpc_server_register_method(server, method_name, host, payload_handling, flags);
    if (method == null) {
        std.debug.print("Failed to register the gRPC method.\n", .{});
        return error.FailedToRegisterMethod;
    }

    grpc.grpc_server_start(server);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("gRPC server running on {s}\n", .{target});
}
