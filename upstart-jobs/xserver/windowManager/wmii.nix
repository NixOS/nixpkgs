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
      # stop wmii by
      #   $wmiir xwrite /ctl quit
      # this will cause wmii exiting with exit code 0
      #
      # why this loop?
      # wmii crashes once a month here. That doesn't matter that much
      # wmii can recover very well. However without loop the x session terminates and then your workspace setup is
      # lost and all applications running on X will terminate.
      # Another use case is kill -9 wmii; after rotating screen.
      # Note: we don't like kill for that purpose. But it works (-> subject "wmii and xrandr" on mailinglist)
      windowManager = {
        session = [{
          name = "wmii";
          start = "
            while :; do
              ${pkgs.wmiiSnap}/bin/wmii && break
            done
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
