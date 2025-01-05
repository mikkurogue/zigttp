const std = @import("std");
const Socket = @import("config/socket.zig").Socket;
const Request = @import("config/request.zig");
const Response = @import("config/response.zig");
const Method = Request.RequestMethod;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket: Socket = try Socket.init();

    try stdout.print("Server addr: {any}", .{socket.address});

    var server = try socket.address.listen(.{});

    const connection = try server.accept();

    while (true) {
        var buffer: [1000]u8 = undefined;

        for (0..buffer.len) |i| {
            buffer[i] = 0;
        }

        try Request.read(connection, buffer[0..buffer.len]);
        const req = Request.parse(buffer[0..buffer.len]);

        if (req.method == Method.GET) {
            if (std.mem.eql(u8, req.uri, "/")) {
                try Response.send_200(connection);
            } else {
                try Response.send_404(connection);
            }
        }
    }
}
