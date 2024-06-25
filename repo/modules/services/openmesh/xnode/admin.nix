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
      default = "/var/lib/openmesh-xnode-admin";
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
      default = "https://dpl-staging.openmesh.network/xnodes/functions";
      description = "The remote repository to pull down a configuration from.";
    };

    searchInterval = mkOption {
      type = types.int;
      default = 0;
      description = "Number of seconds between fetching for changes to configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.openmesh-xnode-admin = {
      description = "Openmesh Xnode Administration and Configuration Subsystem Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = ''${lib.getExe cfg.package} -p ${cfg.stateDir} ${cfg.remoteDir} ${toString cfg.searchInterval}''; 
        ExecStartPre = ''-${lib.getExe pkgs.git} clone --branch dev https://github.com/openmesh-network/xnodeos ${cfg.stateDir}/xnodeos'';
        ExecCondition = ''-${lib.getExe pkgs.git} pull --branch dev https://github.com/openmesh-network/xnodeos ${cfg.stateDir}/xnodeos'';
        Restart = "always";
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "openmesh-xnode-admin";
        StateDirectoryMode = "0775";
        RuntimeDirectory = "openmesh-xnode-admin";
        RuntimeDirectoryMode = "0775";
        PrivateTmp = true;
        User="root";
        #DevicePolicy = "closed";
        #LockPersonality = true;
        #PrivateUsers = true;
        #ProtectHome = true;
        #ProtectHostname = true;
        #ProtectKernelLogs = true;
        #ProtectKernelModules = true;
        #ProtectKernelTunables = true;
        #ProtectControlGroups = true;
        #RestrictNamespaces = true;
        #RestrictRealtime = true;
        SystemCallArchitectures = "native";
        Environment="NIX_PATH=nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels";
      };
    };

  };
}
