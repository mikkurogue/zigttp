const std = @import("std");
const Connection = std.net.Server.Connection;

// Few examples
// TODO: implement send 201 403 401 minimum
// TODO  implement internal server errors too like 500, 501, 503, 504 etc

pub fn send_200_with_file(conn: Connection, file: std.fs.File) !void {
    var buffer: [4096]u8 = undefined; // Define a buffer to read the file.
    const reader = file.reader();

    // Read the file content into the buffer.
    const file_size = try reader.readAll(buffer[0..]);

    // Debugging: log the file size.
    std.log.debug("file size: {}", .{file_size});

    // Ensure `buffer[0..file_size]` is correctly treated as `[]u8`.
    const file_content: []u8 = buffer[0..file_size];

    // Construct the HTTP response.
    const response = try std.fmt.allocPrint(
        std.heap.page_allocator,
        "HTTP/1.1 200 OK\nContent-Length: {}\nContent-Type: text/html\nConnection: Closed\n\n{s}",
        .{ file_size, file_content },
    );

    // Write the response to the connection stream.
    defer std.heap.page_allocator.free(response);
    _ = try conn.stream.write(response);
}
pub fn send_200(conn: Connection) !void {
    const message = ("HTTP/1.1 200 OK\nContent-Length: 48" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>Hello, World!</h1></body></html>");
    _ = try conn.stream.write(message);
}

pub fn send_404(conn: Connection) !void {
    const message = ("HTTP/1.1 404 Not Found\nContent-Length: 50" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>File not found!</h1></body></html>");
    _ = try conn.stream.write(message);
}
