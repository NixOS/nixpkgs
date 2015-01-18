# Builds a bunch of docker instances

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.sal.docker;
  pm = config.sal.processManager;

  systemBuilder = ''
    mkdir $out

    echo "$activationScript" > $out/activate
    substituteInPlace $out/activate --subst-var out
    chmod u+x $out/activate
    unset activationScript

    ln -s ${config.system.build.etc}/etc $out/etc
    ln -s ${config.system.path} $out/sw
    echo -n "$nixosVersion" > $out/nixos-version
    echo -n "$system" > $out/system
  '';

  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, systemd units, init scripts, etc.) as well as a script
  # `switch-to-configuration' that activates the configuration and
  # makes it bootable.
  system = pkgs.stdenv.mkDerivation {
      name = "nixos-${config.system.nixosVersion}";
      preferLocalBuild = true;
      buildCommand = systemBuilder;

      inherit (pkgs) utillinux coreutils;

      activationScript = config.system.activationScripts.script;
      nixosVersion = config.system.nixosVersion;
  } ;

  dockerVolumeOptions = {
    hostPath = mkOption {
      description = "Docker volume path on a host.";
      default = "";
      type = types.str;
    };

    volumePath = mkOption {
      description = "Docker volume path in container.";
      type = types.str;
    };

    readOnly = mkOption {
      description = "Docker volume flag indicating if volume is mounted as read only.";
      type = types.bool;
      default = false;
    };
  };

  portOptions = {
    containerPort = mkOption {
      description = "Container port to .";
      type = types.int;
    };

    bindPort = mkOption {
      description = "Host port to bind to.";
      type = types.int;
    };

    bindHost = mkOption {
      description = "Hostname to bind to.";
      type = types.str;
    };
  };

  redirectOptions = { name, config, ... }: {
    options = {
      port = mkOption {
        description = "Local listening port.";
        type = types.int;
      };

      portEnv = mkOption {
        description = "Environment variable name where port is written.";
        example = "DB_PORT_5432_TCP_PORT";
        type = types.str;
      };

      addressEnv = mkOption {
        description = "Environment variable name where address is written.";
        example = "DB_PORT_5432_TCP_ADDR";
        type = types.str;
      };
    };

    config = {
      portEnv = mkDefault "${toUpper name}_${toString config.port}_TCP_PORT";
      addressEnv = mkDefault "${toUpper name}_${toString config.port}_TCP_ADDR";
    };
  };

  dockerContainerOptions = {
    name = mkOption {
      description = "Name of the docker container";
      type = types.str;
      default = "";
    };

    service = mkOption {
      description = "Sal service for docker container.";
    };

    base = mkOption {
      description = "Docker name of the base container to use.";
      type = types.str;
      default = sal.docker.name;
    };

    entrypoint = mkOption {
      description = "Docker container entrypoint script.";
      type = types.package;
    };

    startScript = mkOption {
      description = "Docker container script, that starts process.";
      type = types.lines;
    };

    environment = mkOption {
      description = "Docker container exposed environment variables.";
      default = {};
      type = types.attrsOf (types.either types.str types.package);
    };

    links = mkOption {
      description = "Docker container list of container names to link with.";
      type = types.listOf types.str;
      default = [];
    };

    volumesFrom = mkOption {
      description = "Docker container list of volumes from other containers.";
      type = types.listOf types.str;
      default = [];
    };

    volumes = mkOption {
      description = "Docker container list of volumes to mount.";
      type = types.listOf types.optionSet;
      options = [ dockerVolumeOptions ];
      default = [];
    };

    expose = mkOption {
      description = "Docker container list of ports container exposes.";
      type = types.listOf types.int;
      default = [];
    };

    ports = mkOption {
      description = "Docker container list of ports to bind from a container.";
      type = types.listOf types.optionSet;
      options = [ portOptions ];
      default = [];
    };

    redirects = mkOption {
      description = "List of port redirects for local ports.";
      options = [ redirectOptions ];
      type = types.attrsOf types.optionSet;
      default = {};
    };

    workingDirectory = mkOption {
      description = "Docker container working directory.";
      type = types.nullOr types.path;
      default = null;
    };
  };

  dockerConfig = { name, config, ... }: {
    config.entrypoint = let
    in pkgs.writeScript "docker-${name}-entrypoint" ''
      #!${pkgs.stdenv.shell} -e

      ${concatStringsSep "\n" (mapAttrsToList (n: v:
        "export ${n}='${v}'"
      ) config.environment)}

      mkdir -m 01777 -p /tmp
      mkdir -m 0755 -p /var /var/log /var/lib /var/db
      mkdir -m 0755 -p /nix/var
      mkdir -m 0700 -p /root
      mkdir -m 0755 -p /bin # for the /bin/sh symlink
      mkdir -m 0755 -p /home
      mkdir -m 0755 -p /run

      # For backwards compatibility, symlink /var/run to /run, and /var/lock
      # to /run/lock.
      ln -s /run /var/run
      ln -s /run/lock /var/lock

      mkdir -p /var/setuid-wrappers

      ${system}/activate

      ${concatStringsSep "\n" (mapAttrsToList (n: v:
        "${pkgs.socat}/bin/socat TCP-LISTEN:${toString v.port},fork TCP:\$${v.addressEnv}:\$${v.portEnv} &"
      ) config.redirects)}

      ${optionalString (config.workingDirectory != null)
        "cd ${config.workingDirectory}"
      }

      ${config.startScript}
    '';
  };

in {
  imports = [
    ../../lib/assertions.nix
    ../../../nixos/modules/misc/ids.nix
    ../../../nixos/modules/config/users-groups.nix
    ../../../nixos/modules/system/activation/activation-script.nix
    ../../../nixos/modules/system/etc/etc.nix
    ../../../nixos/modules/security/setuid-wrappers.nix
    ../../../nixos/modules/security/pam.nix
    ../../../nixos/modules/security/pam_usb.nix
    ../../../nixos/modules/config/system-environment.nix
    ../../../nixos/modules/config/nsswitch.nix
    ../../../nixos/modules/config/timezone.nix
    ../../../nixos/modules/programs/shadow.nix
    ../../../nixos/modules/programs/bash/bash.nix
    ../../../nixos/modules/programs/environment.nix
    ../../../nixos/modules/config/system-path.nix
    ../../../nixos/modules/config/shells-environment.nix
    ../../../nixos/modules/services/misc/nix-daemon.nix
    ../../../nixos/modules/misc/version.nix
  ] ++ (import ../../module-list.nix);

  options = {
    system.build = mkOption {
      internal = true;
      default = {};
      description = ''
        Attribute set of derivations used to setup the system.
      '';
    };

    users.ldap.enable = mkOption {
      internal = true;
      default = false;
    };

    services.samba.syncPasswordsByPam = mkOption {
      internal = true;
      default = false;
    };

    boot.isContainer = mkOption {
      internal = true;
      default = true;
    };

    services.avahi.nssmdns = mkOption {
      internal = true;
      default = false;
    };

    services.samba.nsswins = mkOption {
      internal = true;
      default = false;
    };

    krb5.enable = mkOption {
      internal = true;
      default = false;
    };

    systemd = mkSinkUndeclaredOption {};

    sal.docker = {
      containers = mkOption {
        default = {};
        type = types.attrsOf types.optionSet;
        options = [ dockerContainerOptions dockerConfig ];
        description = "List of docker exposed instances.";
      };
    };

  };

  config = {
    sal.systemName = "docker";
    sal.processManager.name = "docker";
    sal.processManager.supports = {
      platforms = [ "x86_64-linux" ];
      users = true;
      privileged = true;
      networkNamespaces = true;
    };
    sal.processManager.envNames = {
      mainPid = "MAINPID";
    };

    sal.docker.containers = mapAttrs (name: service: {
      inherit service;
      name = mkDefault service.name;
      environment = service.environment // {
        PATH = "${makeSearchPath "bin" service.path}:${makeSearchPath "sbin" service.path}";
      };
      links = mkDefault service.requires.services;
      expose = mkDefault (map (p: p.number) service.requires.ports);
      volumes = map (name: {
        volumePath = mkDefault sal.dataContainerPaths."${name}";
      }) service.requires.dataContainers;
      workingDirectory = mkDefault service.workingDirectory;
      startScript = let
        mkScript = cmd:
        let
          command = if cmd == null then null else
            if cmd.command != "" then cmd.command
            else if cmd.script != null then cmd.script
            else null;

        in if command != null then ''
          timeout ${toString cmd.timeout} ${if !cmd.privileged then "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${service.user}" else pkgs.stdenv.shell} <<'EOF'
          ${command}
          EOF
        '' else "";

      in ''
        ${concatStringsSep "\n" (map (name:
        let
          dc = getAttr name config.sal.dataContainers;
          path = getAttr name config.sal.dataContainerPaths;
        in ''
        mkdir -m ${dc.mode} -p ${path}
        chown ${if dc.user == "" then "root" else dc.user} ${path}
        chgrp ${if dc.group == "" then "root" else dc.user} ${path}
        '') service.requires.dataContainers)}

        # Run pre start scripts
        ${mkScript service.preStart}

        # Setup SIGTERM trap
        _term() {
          printf "%s\n" "Caught SIGTERM signal!"
          ${if service.stop != null &&( service.stop.command == "" || service.stop.script == null) then
            ''timeout ${toString service.stop.timeout} \
              kill -${toString service.stop.stopSignal} ${pm.envNames.mainPid.var} 2>/dev/null''
          else
            mkScript service.stop
          }
        }

        trap _term SIGTERM
        trap _term SIGINT

        # Execute program and save pid

        ${if !service.start.privileged then
          "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${service.user}" else pkgs.stdenv.shell} -c "${
          if service.start.command!="" then service.start.command
          else if isDerivation service.start.script then
            service.start.script else
            pkgs.writeText "${name}-start" ''
              #!${pkgs.stdenv.shell}
              ${service.start.script}
            ''}" &
        export ${pm.envNames.mainPid}=$!

        # Run post start scripts
        ${mkScript service.postStart}

        wait
      '';
    }) config.sal.services;

    sal.dataContainerPaths = mapAttrs (n: dc:
      "/var/${dc.type}/${if dc.name != "" then dc.name else n}"
    ) config.sal.dataContainers;
  };
}
