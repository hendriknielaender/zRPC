const std = @import("std");
const grpc = @import("c.zig");

pub fn createChannel(target: [*c]const u8, creds: *grpc.grpc_channel_credentials) !*grpc.grpc_channel {
    return grpc.grpc_channel_create(target, creds, null);
}

test "createChannel" {
    var creds = grpc.grpc_google_default_credentials_create();
    var channel = try createChannel("localhost:50051", creds);
    defer grpc.grpc_channel_destroy(channel);

    // Add more checks here to verify the channel was created correctly
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}
