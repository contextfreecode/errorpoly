const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() error{OutOfMemory}!void {
    const allocator = std.heap.page_allocator;
    const entries = &[_][]const []const u8{
        &.{ "yes", "no", "yes" },
        &.{ "yes", "no", "maybe" },
    };
    for (entries) |entry| {
        if (binarize(allocator, entry)) |text| {
            defer allocator.free(text);
            std.debug.print("{s}\n", .{text});
        } else |err| switch (err) {
            error.BadToken => std.debug.print("bad token\n", .{}),
            else => |other_err| return other_err,
        }
    }
}

pub fn binarize(
    allocator: Allocator,
    tokens: []const []const u8,
) error{ BadToken, OutOfMemory }![]const u8 {
    return mapJoin(allocator, tokens, false, struct {
        pub fn parse(token: []const u8) error{BadToken}![]const u8 {
            if (std.mem.eql(u8, token, "yes")) {
                return "1";
            } else if (std.mem.eql(u8, token, "no")) {
                return "0";
            } else {
                return error.BadToken;
            }
        }
    }.parse, .{});
}

pub fn mapJoin(
    allocator: Allocator,
    items: anytype,
    freeing: bool,
    func: anytype,
    args: anytype,
    // Standard inference just works here, so manual effort unneeded:
    // ) WithExtraErr(ReturnType(func), error{OutOfMemory}![]const u8) {
) ![]const u8 {
    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();
    for (items) |item| {
        const text = try @call(.auto, func, .{item} ++ args);
        if (freeing) {
            defer allocator.free(text);
        }
        try buffer.appendSlice(text);
    }
    return buffer.toOwnedSlice();
}

// Below functions aren't actually needed.

fn ReturnType(func: anytype) type {
    return @typeInfo(@TypeOf(func)).@"fn".return_type.?;
}

fn WithExtraErr(E: type, R: type) type {
    // Extra errors from E.
    const err_info = @typeInfo(E);
    const extra = if (err_info == .error_union)
        err_info.error_union.error_set
    else
        error{};
    // Errors from R.
    const ret_info = @typeInfo(R);
    const ret_err = if (ret_info == .error_union)
        ret_info.error_union.error_set
    else
        error{};
    // Main return type.
    const ret = if (ret_info == .error_union)
        ret_info.error_union.payload
    else
        R;
    return (extra || ret_err)!ret;
}
