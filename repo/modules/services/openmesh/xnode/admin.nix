{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.openmesh.xnode.admin;
  package = cfg.package;
in 
{
  meta.maintainers = with maintainers; [ harrys522 ];

  options.services.openmesh.xnode.admin = {
    enable = mkEnableOption "Management service for Xnode";

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/openmesh-xnode-admin/default.nix";
      description = "State storage directory.";
    };

    localStateFilename = mkOption {
      type = types.str;
      default = "config.nix";
      description = "Local file destination for nix configurations.";
    };

    package = mkOption {
      type = types.package;
      default = (pkgs.callPackage ../../../../pkgs/openmesh/xnode/admin {});
      description = "Specify xnode-admin package to use";
    };

    remoteDir = mkOption {
      type = types.str;
      default = "https://openmesh.network/xnodes/functions";
      description = "The remote repository to pull down a configuration from.";
    };

    searchInterval = mkOption {
      type = types.int;
      default = 0;
      description = "Number of seconds between fetching for changes to configuration.";
    };
    # Todo: UUID + PSK implementation
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.openmesh-xnode-admin = {
      description = "Openmesh Xnode Administration and Configuration Subsystem Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = ''${lib.getExe cfg.package} -p ${cfg.stateDir}/${cfg.localStateFilename} ${cfg.remoteDir} ${toString cfg.searchInterval}''; 
        Restart = "always";
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "openmesh-xnode-admin";
        RuntimeDirectory = "openmesh-xnode-admin";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DynamicUser = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

  };
}
