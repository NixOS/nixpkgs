{ config, pkgs, ... }:

with pkgs.lib;

let
  pm = config.sal.processManager;
  cfg = config.sal.supervisor;

  serviceOptions = { config, name, ... }: {
    options = {
      name = mkOption {
        description = "Name of the service.";
        type = types.str;
      };

      command = mkOption {
        description = "Supervisor command to execute to start service.";
        type = types.package;
      };

      processname = mkOption {
        description = "Supervisor name of the process.";
        default = "";
        type = types.str;
      };

      pidfile = mkOption {
        description = ''
          Service pid file location.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      forking = mkOption {
        description = ''
          Whether service is forking itself.
        '';
        default = false;
        type = types.bool;
      };

      directory = mkOption {
        description = ''
          A file path representing a directory to which supervisord should temporarily
          chdir before exec’ing the child.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      environment = mkOption {
        description = "Supervisor service environment variables.";
        default = {};
        type = types.attrsOf (types.either types.str types.package);
      };

      stopsignal = mkOption {
        description = ''
          The signal used to kill the program when a stop is requested. This can be
          any of TERM, HUP, INT, QUIT, KILL, USR1, or USR2.
        '';
        default = "TERM";
        type = types.enum ["TERM" "HUP" "INT" "QUIT" "KILL" "USR1" "USR2"];
      };

      stopwaitsecs = mkOption {
        description = ''
          The number of seconds to wait for the OS to return a SIGCHILD to
          supervisord after the program has been sent a stopsignal. If this number
          of seconds elapses before supervisord receives a SIGCHILD from the process,
          supervisord will attempt to kill it with a final SIGKILL.
        '';
        default = 3;
        type = types.int;
      };

      stopasgroup = mkOption {
        description = ''
          If true, the flag causes supervisor to send the stop signal to the whole
          process group and implies killasgroup is true. This is useful for programs,
          such as Flask in debug mode, that do not propagate stop signals to their
          children, leaving them orphaned.
        '';
        default = false;
        type = types.bool;
      };

      killasgroup = mkOption {
        description = ''
          If true, when resorting to send SIGKILL to the program to terminate it
          send it to its whole process group instead, taking care of its children
          as well, useful e.g with Python programs using multiprocessing.
        '';
        default = false;
        type = types.bool;
      };

      exitcodes = mkOption {
        description = ''
          The list of “expected” exit codes for this program. If the autorestart
          parameter is set to unexpected, and the process exits in any other way
          than as a result of a supervisor stop request, supervisord will restart
          the process if it exits with an exit code that is not defined in this list.
        '';
        type = types.listOf types.int;
      };

      autostart = mkOption {
        description = ''
          If true, this program will start automatically when supervisord is
          started.
        '';
        type = types.bool;
        default = true;
      };

      autorestart = mkOption {
        description = ''
          May be one of false, unexpected, or true. If false, the process will
          never be autorestarted. If unexpected, the process will be restart when
          the program exits with an exit code that is not one of the exit codes
          associated with this process’ configuration (see exitcodes). If true,
          the process will be unconditionally restarted when it exits, without
          regard to its exit code.
        '';
        default = "unexpected";
      };

      section = mkOption {
        description = ''
          Service configuration section in supervisor config.
        '';
        example = ''
          [program:cat]
          command=/bin/cat
          process_name=%(program_name)s
          numprocs=1
          directory=/tmp
          umask=022
          priority=999
          autostart=true
          autorestart=true
          startsecs=10
          startretries=3
          exitcodes=0,2
          stopsignal=TERM
          stopwaitsecs=10
          user=chrism
          redirect_stderr=false
          environment=A="1",B="2"
          serverurl=AUTO
        '';
        type = types.lines;
        internal = true;
      };
    };

    config = let
      b2s = value: if value then "true" else "false";
    in {
      section = ''
      [program:${config.name}]
      command=${
        if config.forking then
          "${pkgs.pythonPackages.supervisor}/bin/pidproxy ${config.pidfile} ${config.command}"
        else
          config.command
      }
      process_name=${if config.processname!="" then config.processname else "%(program_name)s"}
      ${optionalString (config.directory != null) "directory=${config.directory}"}
      autostart=${b2s config.autostart}
      autorestart=${if isBool config.autorestart then b2s config.autorestart else config.autorestart}
      stopwaitsecs=${toString config.stopwaitsecs}
      stopsignal=${config.stopsignal}
      stopasgroup=${b2s config.stopasgroup}
      killasgroup=${b2s config.killasgroup}
      exitcodes=${concatMapStringsSep "," toString config.exitcodes}
      '';
    };
  };
in {
  imports = [
    ../../lib/assertions.nix
  ] ++ (import ../../module-list.nix);

  options = {
    sal.supervisor = {
      services = mkOption {
        description = "List of supervisord services.";
        type = types.attrsOf types.optionSet;
        options = [ serviceOptions ];
      };

      stateDir = mkOption {
        description = "Service state directory.";
        type = types.path;
      };

      port = mkOption {
        description = "Supervisord listening port.";
        type = types.int;
        default = 65123;
      };

      unprivilegedUser = mkOption {
        description = ''
          Unprivileged user to run services with. This is required if supervisor
          is running as root and service requires to drop privileges.
        '';
        type = types.str;
        default = "nobody";
      };

      config = mkOption {
        description = "Supervisord configuration.";
        type = types.package;
        internal = true;
      };
    };

    environment.systemPackages = mkOption {};

    users = mkSinkUndeclaredOptions {};
  };

  config = {
    sal.systemName = "linux";
    sal.processManager.name = "supervisor";
    sal.processManager.supports = {
      platforms = platforms.unix;
      fork = true;

      # Supervisor can drop privileges if it is privileged and has unprivileged
      # user that it can drop to avalible
      dropPrivileges =
        pm.supports.privileged && sal.supervisor.unprivilegedUser != "";
    };
    sal.processManager.envNames = {
      mainPid = "MAINPID";
    };

    sal.supervisor.services = mapAttrs (name: service: {
      name = mkDefault service.name;
      command =
      let

        runUnPrivileged = cmd:
          !cmd.privileged &&
          pm.supports.privileged &&
          cfg.unprivilegedUser != "";

        mkScript = cmd:
        let
          command = if cmd == null then null else
            if cmd.command != "" then cmd.command
            else if cmd.script != "" then cmd.script
            else null;

        in if command != null then ''
          timeout ${toString cmd.timeout} ${if runUnPrivileged cmd then "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} $ cfg.unprivilegedUser}" else pkgs.stdenv.shell} <<'EOF'
          ${command}
          EOF
        '' else "";

      in (pkgs.writeScript "supervisor-${name}-service" ''
        #!${pkgs.stdenv.shell} -e

        export PATH="${makeSearchPath "bin" service.path}:${makeSearchPath "sbin" service.path}"
        ${concatStrings (mapAttrsToList (k: v: "export ${k}=\"${v}\"\n") service.environment)}

        ${concatStringsSep "\n" (map (name:
        let
          dc = getAttr name config.resources.dataContainers;
        in ''
        mkdir -m ${dc.mode} -p ${dc.path}
        ${optionalString (pm.supports.privileged && dc.user != "")
          "chown $ cfg.unprivilegedUser} ${dc.path}" }
        '') service.requires.dataContainers)}

        # Setup SIGTERM trap
        _term() {
          ${if service.stop.command == "" && service.stop.script == "" then
            ''timeout ${toString service.stop.timeout} \
              kill -${toString service.stop.stopSignal} ${pm.envNames.mainPid.var} 2>/dev/null''
          else
            mkScript service.stop
          }
        }

        trap _term SIGTERM
        trap _term SIGINT

        ${mkScript service.preStart}
        ${if runUnPrivileged service.start then
          "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${cfg.unprivilegedUser}" else pkgs.stdenv.shell} -c "${
          if service.start.command!="" then service.start.command
          else if isDerivation service.start.script then
            service.start.script else
            pkgs.writeText "${name}-start" ''
              #!${pkgs.stdenv.shell}
              ${service.start.script}
            ''}" &
        export ${pm.envNames.mainPid}=$!
        ${mkScript service.postStart}
        wait ${pm.envNames.mainPid.var}
      '');
      processname = service.start.processName;
      pidfile = service.pidFile;
      forking = if service.type == "forking" then true else false;
      directory = service.workingDirectory;
      stopsignal = service.stop.stopSignal;
      stopwaitsecs = service.stop.timeout;
      stopasgroup = (if service.stop.stopMode == "group" then true else false);
      killasgroup = (if service.stop.stopMode == "mixed" || service.stop.stopMode == "group" then true else false);
      autorestart =
        if service.restart == "no" then false else
        if service.restart == "failure" then "unexpected" else true;
      exitcodes = service.exitCodes;
    }) config.sal.services;

    sal.supervisor.config = pkgs.writeText "supervisord.conf" ''
      [supervisord]
      pidfile=${cfg.stateDir}/run/supervisord.pid
      childlogdir=${cfg.stateDir}/log/
      logfile=${cfg.stateDir}/log/supervisord.log

      [supervisorctl]
      serverurl = http://localhost:${toString cfg.port}

      [inet_http_server]
      port = 127.0.0.1:${toString cfg.port}

      [rpcinterface:supervisor]
      supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

      ${concatMapStringsSep "\n" (s: s.section) (attrValues cfg.services)}
    '';

    resources.dataContainerMapping =
      dc: "${cfg.stateDir}/${dc.type}/${dc.name}";
  };
}
