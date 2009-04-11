{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.wmii;

  option = { services = { xserver = { windowManager = {

    wmii = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the wmii window manager.";
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
          name = "wmii";
          start = "
            ${pkgs.wmiiSnap}/bin/wmii &
            waitPID=$!
          ";
        }];
      };

    };
  };

  environment = {
    extraPackages = [
      pkgs.wmiiSnap
    ];
  };
}
