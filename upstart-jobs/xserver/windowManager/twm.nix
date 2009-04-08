{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.twm;
  xorg = config.services.xserver.package;

  option = { services = { xserver = { windowManager = {

    twm = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the twm window manager.";
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
          name = "twm";
          start = "
            ${xorg.twm}/bin/twm &
            waitPID=$!
          ";
        }];
      };

    };
  };

  environment = {
    extraPackages = [ xorg.twm ];
  };
}
