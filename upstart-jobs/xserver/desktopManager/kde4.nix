{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.desktopManager.kde4;
  xorg = config.services.xserver.package;

  options = { services = { xserver = { desktopManager = {

    kde4 = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the kde 4 desktop manager.";
      };
    };

  }; }; }; };
in

mkIf cfg.enable {
  require = options;

  services = {
    xserver = {

      desktopManager = {
        session = [{
          name = "kde4";
          start = ''
            # Start KDE.
            exec ${pkgs.kde42.kdebase_workspace}/bin/startkde
          '';
        }];
      };

    };
  };

  security = {
    extraSetuidPrograms = [
      "kcheckpass"
    ];
  };

  environment = {
    extraPackages = [
      xorg.xmessage # so that startkde can show error messages
      pkgs.qt4 # needed for qdbus
      pkgs.kde42.kdelibs
      pkgs.kde42.kdebase
      pkgs.kde42.kdebase_runtime
      pkgs.kde42.kdebase_workspace
      pkgs.kde42.kdegames
      pkgs.shared_mime_info
      xorg.xset # used by startkde, non-essential
    ];

    etc = [
      { source = ../../../etc/pam.d/kde;
        target = "pam.d/kde";
      }
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      }
    ];
  };
}
