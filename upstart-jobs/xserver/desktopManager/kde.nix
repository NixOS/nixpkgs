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
  require = options;

  services = {
    xserver = {

      desktopManager = {
        session = [{
          name = "kde";
          start = ''
            # Start KDE.
            export KDEDIRS=$HOME/.nix-profile:/nix/var/nix/profiles/default:${pkgs.kdebase}:${pkgs.kdelibs}
            export XDG_CONFIG_DIRS=${pkgs.kdebase}/etc/xdg:${pkgs.kdelibs}/etc/xdg
            export XDG_DATA_DIRS=${pkgs.kdebase}/share
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
    extraPackages = [
      pkgs.kdelibs
      pkgs.kdebase
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
