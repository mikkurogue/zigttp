/// TODO:
/// serve files from a certain directory as html, js and css to the browser.
/// Add support for php too fuck it we ball. laravel devs drive lambos
/// Make sure it can also serve slop like React or Next dist folders
/// Think LAMPP or XAMPP but written by a total halfwit
///
/// NOTE: Proposed structure of serving:
/// www/index.html -> this will always take precedence over anything else.
/// www/my-website/index.html -> explicitly requires user to navigate to url.com/my-website
/// www/dist/index.html -> for instance if using a bundled output from react, next, angular or whatever
///
/// NOTE: Proposed configuration for the tool itself
/// - Add a "default path" to always serve from, default config should mean this is just www/index.html
/// - Add a "fallback path" in case the "default path" is unavailable - this in reality wont ever actually do anything
/// but it should make things a bit easier to comprehend or have something for when ftp rollouts are happening
/// (we dont do docker here - we do rawdogging ftp:// to the vps - devops is literally overrated and expensive
/// for no reason btw)
/// - Configure the port(s) allowed. However always default to 8080 for http and 443 for https.
///  On a real instance this is probably preferred.
///
/// NOTE: Also figure out if we want the config to be a file, or embedded into the binary with changes allowed.
///
/// NOTE: We only target linux systems, because who installs windows nowadays on a vps like come on man
/// get over yourself. Stop using windows its literal spyware
const std = @import("std");
const fs = std.fs;
const Dir = fs.Dir;
const File = fs.File;
const OpenErr = fs.File.OpenError;
const Response = @import("../config/response.zig");
const Connection = std.net.Server.Connection;
const MimeType = @import("../config/request.zig").MimeType;
const empty_config = .{};

/// Serve a singular file (i.e. www/index.html)
pub const ServeFile = struct {
    connection: Connection,
    path: []const u8,
    // file_type: MimeType,

    pub fn serve(self: *ServeFile) !void {
        const file = fs.cwd().openFile(self.path, empty_config) catch |e| {
            if (e == OpenErr.FileNotFound) {
                std.log.debug("File not found: {s}\n", .{self.path});
                try Response.send_404(self.connection);
                return;
            }
            return e;
        };
        defer file.close();

        // std.log.debug("serving file: {s}\n", .{self.path});

        try Response.send_200_with_file(self.connection, file);
    }
};

/// Serve a directory with a root file (i.e. www/my-website/index.html)
pub const ServeDirectory = struct {};

/// Serve a sub-directory with a root file.
/// Not yet sure how i want to do this
pub const ServeSubDirectory = struct {};

/// make the default serve directory. this is named www/ in zigttp
fn mk_def_dir() !void {
    const cwd: Dir = fs.cwd();

    try cwd.makeDir("www");
}

fn check_def_dir_exists() !void {
    var cwd: Dir = fs.cwd();
    _ = try cwd.openDir("www", empty_config);
    defer cwd.close();
}

/// Make the default index.html file in the www folder
fn mk_def_index() !void {
    const index_html: File = fs.cwd().createFile("www/index.html", empty_config) catch |err| switch (err) {
        // If the file already exists, means we have made it (or a user has made a previous one) so we can ignore
        // the error, lets just continue on - need to do a "read from dir" function and determine if it exists or not at a later
        // date
        OpenErr.PathAlreadyExists => return,
        else => return err,
    };
    defer index_html.close();

    const page = try index_html.write("<h1>Let's get Ziggy!</h1>");
    _ = page;
}

fn check_index_html_exists() !File {
    const file = try fs.cwd().openFile("www/index.html", empty_config);

    return file;
}
