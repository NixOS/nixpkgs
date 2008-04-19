# This file defines the options that can be used both for the Apache
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{forMainServer, mkOption}:

{

  hostName = mkOption {
    default = "localhost";
    description = "
      Canonical hostname for the server.
    ";
  };

  serverAliases = mkOption {
    default = [];
    example = ["www.example.org" "www.example.org:8080" "example.org"];
    description = "
      Additional names of virtual hosts served by this virtual host configuration.
    ";
  };

  httpPort = mkOption {
    default = 80;
    description = "
      Port for unencrypted HTTP requests.
    ";
  };

  httpsPort = mkOption {
    default = 443;
    description = "
      Port for encrypted HTTPS requests.
    ";
  };

  enableHttp = mkOption {
    default = true;
    description = "
      Whether to listen on unencrypted HTTP.
    ";
  };

  enableHttps = mkOption {
    default = false;
    description = "
      Whether to listen on encrypted HTTPS.
    ";
  };

  adminAddr = mkOption ({
    example = "admin@example.org";
    description = "
      E-mail address of the server administrator.
    ";
  } // (if forMainServer then {} else {default = "";}));

  documentRoot = mkOption {
    default = null;
    example = "/data/webserver/docs";
    description = "
      The path of Apache's document root directory.  If left undefined,
      an empty directory in the Nix store will be used as root.
    ";
  };

  servedDirs = mkOption {
    default = [];
    example = [
      { urlPath = "/nix";
        dir = "/home/eelco/Dev/nix-homepage";
      }
    ];
    description = "
      This option provides a simple way to serve static directories.
    ";
  };

  servedFiles = mkOption {
    default = [];
    example = [
      { urlPath = "/foo/bar.png";
        dir = "/home/eelco/some-file.png";
      }
    ];
    description = "
      This option provides a simple way to serve individual, static files.
    ";
  };

  extraConfig = mkOption {
    default = "";
    example = ''
      <Directory /home>
        Options FollowSymlinks
        AllowOverride All
      </Directory>
    '';
    description = "
      These lines go to httpd.conf verbatim. They will go after
      directories and directory aliases defined by default.
    ";
  };

  extraSubservices = mkOption {
    default = [];
    description = "
      Extra subservices to enable in the webserver.
    ";
  };

}
