# Disnix server
{config, pkgs}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      disnix = {
        enable = mkOption {
          default = false;
          description = "Whether to enable Disnix";
        };
        
        activateHook = mkOption {
          default = "";
          description = "Custom script or executable that activates services through Disnix";
        };

        deactivateHook = mkOption {
          default = "";
          description = "Custom script or executable that deactivates services through Disnix";
        };
      };
    };
  };
in

###### implementation
let
  cfg = config.services.disnix;
  ifEnable = pkgs.lib.ifEnable cfg.enable;

  job = {
    name = "disnix";
        
    job = ''
      description "Disnix server"

      start on dbus
      stop on shutdown  
          
      start script
        # !!! quick hack: wait until dbus has started
        sleep 3
      end script
      
      respawn ${pkgs.bash}/bin/sh -c 'export PATH=/var/run/current-system/sw/bin:$PATH; export HOME=/root; export DISNIX_ACTIVATE_HOOK=${cfg.activateHook}; export DISNIX_DEACTIVATE_HOOK=${cfg.deactivateHook}; ${pkgs.disnix}/bin/disnix-service'
    '';
  };
in

{
  require = [
    (import ../upstart-jobs/default.nix)
    (import ../upstart-jobs/dbus.nix) # services.dbus.*
    options
  ];

  services = {
    extraJobs = ifEnable [job];

    dbus = {
      enable = cfg.enable;
      services = ifEnable [pkgs.disnix];
    };
  };
}
