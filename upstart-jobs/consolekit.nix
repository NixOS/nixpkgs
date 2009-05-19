{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {

      consolekit = {
        enable = mkOption {
          default = false;
          description = "
            Whether to start the ConsoleKit daemon.
          ";
        };
      };

    };
  };
in

###### implementation
let
  cfg = config.services.consolekit;
  inherit (pkgs.lib) mkIf;
  inherit (pkgs) ConsoleKit;

  job = {
    name = "consolekit";

    job = ''
      description "Console Kit Service"

      start on dbus
      stop on shutdown

      respawn ${ConsoleKit}/sbin/console-kit-daemon
    '';
  };

in

mkIf cfg.enable {
  require = [
    ../upstart-jobs/default.nix # config.services.extraJobs
    ../upstart-jobs/dbus.nix # services.dbus.*
    options
  ];

  services = {
    extraJobs = [job];

    dbus = {
      enable = true;
      services = [ConsoleKit];
    };
  };
}
