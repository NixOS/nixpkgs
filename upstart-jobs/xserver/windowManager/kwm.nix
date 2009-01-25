{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.kwm;

  option = { services = { xserver = { windowManager = {

    kwm = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the kwm window manager.";
      };

    };

  }; }; }; };
in

mkIf cfg.enable {
  require = option;

  services = {
    xserver = {

      windowManager = {
        session = [{
          name = "kwm";
          start = "
            ${pkgs.kdebase}/bin/kwin &
            waitPID=$!
          ";
        }];
      };

    };
  };

  environment = {
    extraPackages = [
      pkgs.kdelibs
      pkgs.kdebase
    ];
  };
}
