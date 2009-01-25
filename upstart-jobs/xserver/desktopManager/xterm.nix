{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.desktopManager.xterm;

  options = { services = { xserver = { desktopManager = {

    xterm = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable a xterm terminal as a desktop manager.";
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
          name = "xterm";
          start = ''
            ${pkgs.xterm}/bin/xterm -ls &
            waitPID=$!
          '';
        }];
      };

    };
  };

  environment = {
    extraPackages = [
      pkgs.xterm
    ];
  };
}
