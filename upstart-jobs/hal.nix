# HAL daemon.
{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      hal = {
        enable = mkOption {
          default = true;
          description = "
            Whether to start the HAL daemon.
          ";
        };
      };
    };
  };
in

###### implementation
let
  cfg = config.services.hal;
  inherit (pkgs.lib) mkIf;

  inherit (pkgs) hal;

  user = {
    name = "haldaemon";
    uid = (import ../system/ids.nix).uids.haldaemon;
    description = "HAL daemon user";
  };

  group = {
    name = "haldaemon";
    gid = (import ../system/ids.nix).gids.haldaemon;
  };


  job = {
    name = "hal";
    
    job = ''
      description "HAL daemon"

      # !!! TODO: make sure that HAL starts after acpid,
      # otherwise hald-addon-acpi will grab /proc/acpi/event.
      start on dbus
      stop on shutdown

      start script

          # !!! quick hack: wait until dbus has started
          sleep 3

          mkdir -m 0755 -p /var/cache/hald

      end script

      respawn ${hal}/sbin/hald --daemon=no
    '';
  };
in

mkIf cfg.enable {
  require = [
    (import ../upstart-jobs/default.nix) # config.services.extraJobs
    # (import ../system/user.nix) # users.*
    # (import ../upstart-jobs/udev.nix) # services.udev.*
    (import ../upstart-jobs/dbus.nix) # services.dbus.*
    # (import ?) # config.environment.extraPackages
    options
  ];

  environment = {
    extraPackages = [hal];
  };

  users = {
    extraUsers = [user];
    extraGroups = [group];
  };

  services = {
    extraJobs = [job];

    udev = {
      addUdevPkgs = [hal];
    };

    dbus = {
      enable = true;
      services = [hal];
    };
  };
}
