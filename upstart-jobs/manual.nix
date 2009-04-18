{pkgs, config, ...}:

# Show the NixOS manual on tty7
# Originally used only by installation CD

let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {

      showManual = {

        enable = mkOption {
          default = false;
          description = "
            Whether to show the NixOS manual on the tty7
          ";
        };

        ttyNumber = mkOption {
          default = "7";
          description = "
            TTY number name to show the manual on
          ";
        };

        browserPackage = mkOption {
          default = pkgs.w3m;
          description = "
            Package containing the browser to be used
          ";
        };

        browserCommand = mkOption {
          default = "bin/w3m";
          description = "
            Command (command path is relative to browserPackage) to run the browser
          ";
        };

        manualFile = mkOption {
          default = null;
          description = "
            NixOS manual HTML file
          ";
        };

      }; # showManual

    }; # services
  };
in

let
  cfg = config.services.showManual;
in let # !!! Bug in Nix 0.13pre14722, otherwise the following line is not aware of cfg.
  inherit (cfg) enable ttyNumber browserPackage browserCommand manualFile;

  realManualFile =
    if manualFile == null then
      (import ../doc/manual {nixpkgs = pkgs;})+"/manual.html"
    else
      manualFile;

  inherit (pkgs.lib) mkIf mkThenElse;
in

mkIf enable {
  require = [
    options
  ];

  boot = {
    extraTTYs = [ ttyNumber ];
  };

  services = {

    extraJobs = [{
      name = "showManual";

      job = ''
        description "NixOS manual"

        start on udev
        stop on shutdown
        respawn ${browserPackage}/${browserCommand} ${realManualFile} < /dev/tty${toString ttyNumber} > /dev/tty${toString ttyNumber} 2>&1
      '';
    }];

    ttyBackgrounds = {
      specificThemes = [{
        tty = ttyNumber;
        theme = pkgs.themes "green";
      }];
    };

    mingetty = {
      helpLine = mkThenElse {
        thenPart = "\nPress <Alt-F${toString ttyNumber}> for NixOS manual.";
        elsePart = "";
      };
    };

  };
}
