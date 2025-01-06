const std = @import("std");
const Socket = @import("config/socket.zig").Socket;
const Request = @import("config/request.zig");
const Response = @import("config/response.zig");
const Method = Request.RequestMethod;
const stdout = std.io.getStdOut().writer();
const StringEqual = std.mem.eql;
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

        const file_path = try std.fmt.allocPrint(std.heap.page_allocator, "www{s}", .{req.uri});
        defer std.heap.page_allocator.free(file_path);

        const ext = try Request.determine_extension(file_path);
        const mime = try Request.determine_mimetype(ext);
        _ = mime;
        // std.log.debug("mime: {!}", .{mime});

        if (req.method == Method.GET) {
            if (StringEqual(u8, req.uri, "/")) {
                var serve_file = ServeFile{
                    .connection = connection,
                    .path = file_path,
                };
                const result = serve_file.serve();
                result catch |e| {
                    std.log.debug("Serve file error: {any}", .{e});
                    break;
                };
            } else {
                try Response.send_404(connection);
            }
        }
    }
}
