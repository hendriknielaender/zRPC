const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = setupSharedLibrary(b, "zRPC", "src/main.zig", target, optimize, std.SemanticVersion{ .major = 0, .minor = 1, .patch = 0 });
    b.installArtifact(lib);

    const main_tests = setupTest(b, "src/main.zig", target, optimize);
    const run_main_tests = b.addRunArtifact(main_tests);

    setupTestStep(b, &run_main_tests.step);
}

fn setupSharedLibrary(b: *std.Build, name: []const u8, root_source: []const u8, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, version: std.SemanticVersion) *std.Build.Step.Compile {
    const lib = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = .{ .path = root_source },
        .target = target,
        .optimize = optimize,
        .version = version,
    });
    lib.linkLibC();
    lib.addIncludePath(.{ .path = "grpc/include" });
    return lib;
}

fn setupTest(b: *std.Build, root_source: []const u8, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step.Compile {
    const test_lib = b.addTest(.{
        .root_source_file = .{ .path = root_source },
        .target = target,
        .optimize = optimize,
    });
    test_lib.linkLibC();
    test_lib.addIncludePath(.{ .path = "grpc/include" });
    return test_lib;
}

fn setupTestStep(b: *std.Build, run_main_tests: *std.Build.Step) void {
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(run_main_tests);
}
