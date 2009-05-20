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

        extraFdi = mkOption {
          default = [];
          example = [ "/nix/store/.../fdi" ];
          description = "
            Extend HAL daemon configuration with additionnal paths.
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

  fdi =
    if cfg.extraFdi == [] then
      hal + "/share/hal/fdi"
    else
      pkgs.buildEnv {
        name = "hal-fdi";
        pathsToLink = [ "/preprobe" "/information" "/policy" ];
        paths = [ (hal + "/share/hal/fdi") ] ++ cfg.extraFdi;
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

      # HACK ? These environment variables manipulated inside
      # 'src'/hald/mmap_cache.c are used for testing the daemon
      env HAL_FDI_SOURCE_PREPROBE=${fdi}/preprobe
      env HAL_FDI_SOURCE_INFORMATION=${fdi}/information
      env HAL_FDI_SOURCE_POLICY=${fdi}/policy

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
