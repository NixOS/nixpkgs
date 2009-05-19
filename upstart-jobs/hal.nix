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
      start on ${if config.powerManagement.enable then "acpid" else "dbus"}
      stop on shutdown

      start script

          mkdir -m 0755 -p /var/cache/hald
          
          rm -f /var/cache/hald/fdi-cache

      end script

      respawn ${hal}/sbin/hald --daemon=no
    '';
  };
in

mkIf cfg.enable {
  require = [
    ../upstart-jobs/default.nix # config.services.extraJobs
    # ../system/user.nix # users.*
    # ../upstart-jobs/udev.nix # services.udev.*
    ../upstart-jobs/dbus.nix # services.dbus.*
    # ? # config.environment.extraPackages
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
