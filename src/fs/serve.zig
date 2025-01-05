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

/// Serve a singular file (i.e. www/index.html)
pub const ServeFile = struct {};

/// Serve a directory with a root file (i.e. www/my-website/index.html)
pub const ServeDirectory = struct {};

/// Serve a sub-directory with a root file.
/// Not yet sure how i want to do this
pub const ServeSubDirectory = struct {};
