const std = @import("std");
const grpc = @import("c.zig");

test "grpc_import_test" {
    _ = grpc.GRPC_CALL_OK;
}

// Wrap basic gRPC functionality in Zig-native functions.
pub fn createChannel(target: []const u8, creds: ?*grpc.grpc_channel_credentials) ?*grpc.grpc_channel {
    const c_target = grpc.grpc_slice_from_copied_buffer(target.ptr, target.len);
    defer grpc.grpc_slice_unref(c_target);

    return grpc.grpc_channel_create(target.ptr, creds, null);
}

pub fn defaultCredentials() ?*grpc.grpc_channel_credentials {
    return grpc.grpc_google_default_credentials_create(null);
}

pub fn destroyChannel(channel: *grpc.grpc_channel) void {
    grpc.grpc_channel_destroy(channel);
}

pub fn main() !void {
    const target = "localhost:50051";
    const creds = defaultCredentials() orelse return error.FailedToCreateCredentials;
    // As the creds are non-nullable, you don't need to handle them as optional.

    const channel = createChannel(target, creds) orelse return error.FailedToCreateChannel;
    defer destroyChannel(channel);

    // As a placeholder, we print a message. In practice, you'd start making RPCs or other gRPC-related tasks here.
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Successfully created gRPC channel to {s}.\n", .{target});
}
