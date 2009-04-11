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
  require = [
    options

    # environment.kdePackages
    (import ./kdeEnvironment.nix)
  ];

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
    kdePackages = [
      pkgs.kde42.kdelibs
      pkgs.kde42.kdebase
      pkgs.kde42.kdebase_runtime
      pkgs.kde42.kdebase_workspace
      pkgs.shared_mime_info
    ];

    extraPackages = [
      xorg.xmessage # so that startkde can show error messages
      pkgs.qt4 # needed for qdbus
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
