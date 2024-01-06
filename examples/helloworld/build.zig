const std = @import("std");
const protobuf = @import("protobuf");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    //const protobuf_dep = b.dependency("protobuf", .{
    //    .target = target,
    //    .optimize = optimize,
    //});

    const exe = b.addExecutable(.{
        .name = "helloworld",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    //const gen_proto = b.step("gen-proto", "generates zig files from protocol buffer definitions");
    //const protoc_step = protobuf.RunProtocStep.create(b, protobuf_dep.builder, .{
    //    .destination_directory = .{
    //        // out directory for the generated zig files
    //       .path = "src/proto",
    //   },
    //    .source_files = &.{
    //       "protocol/helloworld.proto",
    //   },
    //    .include_directories = &.{},
    //});

    //gen_proto.dependOn(&protoc_step.step);
}
