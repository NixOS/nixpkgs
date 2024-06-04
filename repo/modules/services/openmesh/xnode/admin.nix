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

    localDir = mkOption {
      type = types.str;
      default = "/var/lib/openmesh/config.nix";
      description = "Local repository for nix configurations, typically a cloned git repository.";
    };

    package = mkOption {
      type = types.package;
      default = (pkgs.callPackage ../../../../pkgs/openmesh/xnode/admin {});
      description = "Specify xnode-admin package to use";
    };

    remoteDir = mkOption {
      type = types.str;
      default = "openmesh.network/xnodes/functions";
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
    #environment.systemPackages = [ cfg.package ];

    systemd.services.openmesh-xnode-admin = {
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${cfg.package}/src/nix_rebuilder.py \
                    ${cfg.localDir} ${cfg.remoteDir} ${toString cfg.searchInterval}
                    "; 
      };
    };

  };
}
