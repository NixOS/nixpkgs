{ config, lib }:

with lib;

rec {

  commonOptions = {

    description = mkOption {
      default = "";
      type = types.str;
      description = "Description of the sal unit.";
    };

    extra = mkOption {
      default = {};
      type = types.attrsOf types.attrs;
      description = ''
        Per process manager extra options passed to each sal unit.
      '';
    };

  };

  commandOptions = {
    command = mkOption {
      default = "";
      type = types.str;
      description = "Command to execute.";
    };

    script = mkOption {
      default = "";
      type = types.lines;
      description = "Script to execute.";
    };

    privileged = mkOption {
      type = types.bool;
      default = false;
      description = "Run command as privileged.";
    };

    timeout = mkOption {
      default = 30;
      type = types.int;
      description = "Command timeout.";
    };
  };

  startOptions = commandOptions // {
    processName = mkOption {
      default = "";
      type = types.str;
      description = "Name of the process when running command.";
    };
  };

  stopOptions = commandOptions // {
    stopSignal = mkOption {
      default = "TERM";
      type = types.either types.str types.int;
      description = "Signal to stop service.";
    };

    stopMode = mkOption {
      default = "group";
      type = types.enum ["process" "group" "mixed"];
      description = "Specifies how processes shall be stopped.";
    };
  };

  serviceOptions =  { name, config, ... }: {
    options = commonOptions // {
      name = mkOption {
        default = name;
        type = types.str;
        description = ''
          The name of the service.
        '';
      };

      platforms = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          List of supported service platforms.
        '';
      };

      type = mkOption {
        default = "simple";
        type = types.enum ["simple" "one-shot" "forking"];
        description = "Type of serivce.";
      };

      environment = mkOption {
        default = {};
        type = types.attrsOf (types.either types.str types.package);
        example = { PATH = "/foo/bar/bin"; LANG = "nl_NL.UTF-8"; };
        description = "Environment variables passed to the service's processes.";
      };

      path = mkOption {
        default = [];
        description = ''
          Packages added to the service's <envar>PATH</envar>
          environment variable.  Both the <filename>bin</filename>
          and <filename>sbin</filename> subdirectories of each
          package are added.
        '';
      };

      pidFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Service PID file path.
        '';
      };

      user = mkOption {
        default = "";
        type = types.str;
        description = "Run service under speciffic user.";
      };

      group = mkOption {
        default = "";
        type = types.str;
        description = "Run service under speciffic group.";
      };

      start = mkOption {
        default = {};
        type = types.nullOr types.optionSet;
        options = [ startOptions ];
        description = "Command to start service";
      };

      stop = mkOption {
        default = {};
        type = types.nullOr types.optionSet;
        options = [ stopOptions ];
        description = "Command to stop service";
      };

      reload = mkOption {
        default = null;
        type = types.nullOr types.optionSet;
        options = [ commandOptions ];
        description = "Command to reload service";
      };

      preStart = mkOption {
        default = null;
        type = types.nullOr types.optionSet;
        options = [ commandOptions ];
        description = "Command to execute before service start.";
      };

      postStart = mkOption {
        default = null;
        type = types.nullOr types.optionSet;
        options = [ commandOptions ];
        description = "Command to execute after service start.";
      };

      postStop = mkOption {
        default = null;
        type = types.nullOr types.optionSet;
        options = [ commandOptions ];
        description = "Command to execute after service stop.";
      };

      workingDirectory = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = "Service working directory.";
      };

      restart = mkOption (let
        restartConditions = ["success" "failure" "changed"];
      in {
        default = ["changed"];
        apply = value:
          if isList value then value else
          if value == "allways" then restartConditions
          else [value "changed"];
        type = types.uniq (
          types.either
            (types.enum (restartConditions ++ ["allways"]))
            (types.listOf (types.enum restartConditions))
        );
        description = ''
          Conditions when to restart a service. If value is a list
          it must contain one of "success", "failure" and "changed" values.
          If value is a string, it must be one of "sucess", "failure" or
          "allways". At the same time if value is a string "changed" condition
          is allways applied.
        '';
      });

      exitCodes = mkOption {
        default = [0 1 2 15 13];
        type = types.listOf types.int;
        description = "List of exit codes.";
      };

      requires = {
        services = mkOption {
          default = [];
          type = types.listOf types.str;
          description = ''
            List of service dependencies.
          '';
        };

        sockets = mkOption {
          default = [];
          type = types.listOf types.str;
          description = ''
            List of socket names required by service.
          '';
        };

        ports = mkOption {
          default = [];
          type = types.int;
          description = "List of ports service is bound to.";
        };

        dataContainers = mkOption {
          default = [];
          type = types.listOf types.str;
          description = ''
            List of data container names required by service.
          '';
        };

        strictUsersAndGroups = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Requires that service must run under speciffic user and group
            speciffied with user and group parameter. This is for services where
            user and group can't be changed.
          '';
        };

        dropPrivileges = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether service requires that it's phases are run with dropped
            privileges. This is required by some services, which cannot run as
            privileged(as root).
          '';
        };

        networking = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether service requires networking.
          '';
        };

        displayManager = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether service requires display manager.
          '';
        };
      };
    };
  };
}
