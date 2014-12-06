{ config, options, lib, pkgs,  ... }:

with lib;
with import ./service-config.nix { inherit config lib; };

let
  pm = config.sal.processManager;

  serviceConfig = { name, config, ... }: {
    config = mkMerge [
      {
        path = [
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnugrep
          pkgs.gnused
        ];
      }
    ];
  };

in {
  options = {
    sal.services = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ serviceOptions serviceConfig ];
      description = "Definition of sal services.";
    };

    sal.sockets = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ socketOptions ];
      description = "Definition of sal sockets.";
    };

    sal.dataContainers = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ dataContainerOptions ];
      description = "Definition of sal data containers.";
    };

    sal.dataContainerPaths = mkOption {
      default = [];
      type = types.attrsOf types.path;
      description = "Paths to data containers.";
    };

    sal.systemName = mkOption {
      type = types.str;
      description = "Name of the system sal is providing services for.";
      example = "nixos";
    };

    sal.processManager.name = mkOption {
      type = types.str;
      description = "Name of the process manager.";
    };

    sal.processManager.supports = {
      platforms = mkOption {
        default = [ pkgs.lib.stdenv.system ];
        type = types.listOf types.str;
        description = "List of supported platforms by process manager.";
      };

      fork = mkOption {
        default = false;
        type = types.bool;
        description = "Whether process mananager supports processes that forks themselves.";
      };

      syslog = mkOption {
        default = false;
        type = types.bool;
        description = "Whether process manager has syslog.";
      };

      privileged = mkOption {
        default = false;
        type = types.bool;
        description = "Whether process manager is running with system privileges.";
      };

      users = mkOption {
        default = false;
        type = types.bool;
        description = "Whether process manager supports user creation.";
      };

      dropPrivileges = mkOption {
        default = config.sal.processManager.supports.users;
        type = types.bool;
        description = "Whether process manager can drop privileges.";
      };

      socketTypes = mkOption {
        default = [];
        type = types.enum ["inet" "inet6" "unix"];
        description = "List of supported socket types";
      };

      networkNamespaces = mkOption {
        default = false;
        type = types.bool;
        description = "Whether services run in separated network namespaces.";
      };
    };

    sal.processManager.envNames = mkOption {
      default = {};
      apply = el: mapAttrs (n: v: {outPath = v; var = "\$" + v;}) el;
      type = types.attrsOf types.str;
      description = ''
        Environment variable names. If you suffix argument with .var
        you will get environment variable in it's variable form.
      '';
    };
  };

  config = {
    assertions =
      # Check services
      (flatten (mapAttrsToList (n: s:
        [
          # Check platforms
          {
            assertion =
              any (p: contains p pm.supports.platforms) s.platforms;
            message =
              "Service ${n} is not supported on any of the platforms that ${pm.name} supports.";
          }

          # Check drop privileges
          {
            assertion =
              !s.requires.dropPrivileges ||
              (s.requires.dropPrivileges && pm.supports.dropPrivileges);
            message =
              "Service ${n} requires to drop privileges and ${pm.name} has no sane way to do that.";
          }

          # Check strict users and groups
          {
            assertion =
              !s.requires.strictUsersAndGroups ||
              (s.requires.strictUsersAndGroups && pm.supports.users);
            message =
              "Service ${n} requires strict users and groups and ${pm.name} has no users support.";
          }
        ] ++

        # Check privileges
        (
          map (cmd: {
            assertion =
              s."${cmd}" == null ||
              !s."${cmd}".privileged ||
              (s."${cmd}".privileged && pm.supports.privileged);
            message =
              "Service ${n} command for ${cmd} can only start with systems privilges and ${pm.name} does not seem to have them";
          })
          ["start" "stop" "reload" "preStart" "postStart" "postStop"]
        ) ++

        # Check ports
        (
          map (port: mapAttrsToList (n2: s2: {
            assertion =
              !(contains port s2.requires.ports && !pm.supports.networkNamespaces);
            message =
              "Service ${n} ports clash with service ${n2} ports and ${pm.name} does not support network namespaces.";
          }) (filterAttrs (n2: s2: s2 != s) config.sal.services)) s.requires.ports
        )
      ) config.sal.services)) ++

      # Check sockets
      (mapAttrsToList (n: v: [{
        assertion = contains v.type pm.supports.socketTypes;
        message = "Socket ${n} with type ${v.type} is not supported on ${pm.name}.";
      }]) config.sal.sockets);

  };
}
