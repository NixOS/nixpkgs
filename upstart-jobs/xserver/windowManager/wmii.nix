{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.wmii;
in

{
  services = {
    xserver = {

      windowManager = {
        wmii = {
          enable = mkOption {
            default = false;
            example = true;
            description = "Enable the wmii window manager.";
          };
        };

        session = mkIf cfg.enable [{
          name = "wmii";
          start = "
            ${pkgs.wmiiSnap}/bin/wmii &
            waitPID=$!
          ";
        }];
      };

    };
  };
}
