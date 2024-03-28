const std = @import("std");

const clap = @import("clap");

pub fn main() !void {
    const params = comptime clap.parseParamsComptime(
        \\-h, --help     Display this help and exit.
        \\
    );

    var res = try clap.parse(clap.Help, &params, clap.parsers.default, .{});
    defer res.deinit();

    if (res.args.help != 0)
        return clap.help(std.io.getStdErr().writer(), clap.Help, &params, .{});
}
