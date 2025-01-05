const std = @import("std");
const Connection = std.net.Server.Connection;
const Map = std.static_string_map.StaticStringMap;

/// TODO implement post put delete patch
pub const RequestMethod = enum {
    GET,
    POST,
    PUT,
    DELETE,
    PATCH,
    pub fn init(text: []const u8) !RequestMethod {
        return MethodMap.get(text).?;
    }
    pub fn is_supported(method: []const u8) bool {
        const m = MethodMap.get(method);

        if (m) |_| {
            return true;
        }

        return false;
    }
};

/// TODO add other request methods
const MethodMap = Map(RequestMethod).initComptime(.{
    .{ "GET", RequestMethod.GET },
    .{ "POST", RequestMethod.POST },
    .{ "PUT", RequestMethod.PUT },
    .{ "PATCH", RequestMethod.PATCH },
    .{ "DELETE", RequestMethod.DELETE },
});

const Request = struct {
    method: RequestMethod,
    version: []const u8,
    uri: []const u8,
    pub fn init(method: RequestMethod, uri: []const u8, version: []const u8) Request {
        return Request{
            .method = method,
            .uri = uri,
            .version = version,
        };
    }
};

pub fn read(conn: Connection, buffer: []u8) !void {
    const stream_reader = conn.stream.reader();
    _ = try stream_reader.read(buffer);
}

pub fn parse(text: []u8) Request {
    const line_idx = std.mem.indexOfScalar(u8, text, '\n') orelse text.len;
    var iter = std.mem.splitScalar(u8, text[0..line_idx], ' ');

    const method = try RequestMethod.init(iter.next().?);
    const uri = iter.next().?;
    const version = iter.next().?;
    const req = Request.init(method, uri, version);

    return req;
}
