const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() error{OutOfMemory}!void {
    const allocator = std.heap.page_allocator;
    const entries = [_][]const []const u8{
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
) WithErrType(ReturnType(func), error{OutOfMemory}, []const u8) {
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

fn WithErrType(T: type, E: type, Value: type) type {
    const info = @typeInfo(T);
    return if (info == .error_union)
        (info.error_union.error_set || E)!Value
    else
        Value;
}

fn ReturnType(func: anytype) type {
    const ti = @typeInfo(@TypeOf(func));
    return ti.@"fn".return_type.?;
}
