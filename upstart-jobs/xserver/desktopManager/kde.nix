{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.desktopManager.kde;
  xorg = config.services.xserver.package;

  options = { services = { xserver = { desktopManager = {

    kde = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the kde desktop manager.";
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
          name = "kde";
          start = ''
            # Start KDE.
            exec ${pkgs.kdebase}/bin/startkde
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
      pkgs.kdelibs
      pkgs.kdebase
    ];

    extraPackages = [
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
