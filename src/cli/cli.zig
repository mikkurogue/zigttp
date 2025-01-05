/// NOTE:
/// this is the main interface to change the configuration
/// eg:
/// zigttp -port=9292 -secure_port=444
/// or
/// zigttp -default_dir=my-website
/// this isnt meant to be crazy difficult, just the simple cli commands
/// Need to just figure out if this needs to be linked to a .zig.zon configuration
/// that can be read on runtime
/// Also need to think what other commands we need
/// like for instance changing the "main" client pages to be a different url than `www`
const std = @import("std");

pub const Command = enum { start, port, secure_port, default_dir };

/// The main Cli struct, this should expose following methods:
/// start() <- start a new instance of zigttp
/// ch_port()
/// ch_secure_port()
/// ch_default_dir()
///
/// the ch prefix stands for change, as we want to change the internal configuration
pub const Cli = struct {};
