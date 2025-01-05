const std = @import("std");
const builtin = @import("builtin");
const net = std.net;
const posix = std.posix;

pub const Socket = struct {
    address: net.Address,
    stream: net.Stream,

    pub fn init() !Socket {
        const host: [4]u8 = [4]u8{ 127, 0, 0, 1 };
        const port: u16 = 9292;
        const address = net.Address.initIp4(host, port);

        const socket = try posix.socket(address.any.family, posix.SOCK.STREAM, posix.IPPROTO.TCP);
        const stream = net.Stream{ .handle = socket };

        return Socket{ .address = address, .stream = stream };
    }

    pub fn deinit(self: *Socket) !void {
        self.stream.close();
    }
};
