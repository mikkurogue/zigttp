const std = @import("std");
const Socket = @import("config/socket.zig").Socket;
const Request = @import("config/request.zig");
const Response = @import("config/response.zig");
const Method = Request.RequestMethod;
const stdout = std.io.getStdOut().writer();

const ServeFile = @import("fs/serve.zig").ServeFile;

pub fn main() !void {
    const socket: Socket = try Socket.init();

    try stdout.print("Server addr: {any}\n", .{socket.address});

    var server = try socket.address.listen(.{});

    const connection = try server.accept();
    defer server.deinit();
    // FIXME:
    // need to be able to gracefully shutdown the process and kill the socket.
    while (true) {
        var buffer: [1024]u8 = undefined;

        try Request.read(connection, buffer[0..buffer.len]);
        const req = Request.parse(buffer[0..buffer.len]);

        if (req.method == Method.GET) {
            if (std.mem.eql(u8, req.uri, "/")) {
                var serve_file = ServeFile{ .connection = connection };
                const result = serve_file.serve();
                result catch |e| {
                    // TODO: handle cases accordingly.
                    std.log.debug("Serve file error: {any}", .{e});
                    // close socket - this should be graceful enough?
                    socket.deinit();
                    break;
                };
            } else {
                try Response.send_404(connection);
            }
        }
    }
}
