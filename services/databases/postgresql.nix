{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postgresql;
  pm = config.sal.processManager;

  # see description of extraPlugins
  postgresqlAndPlugins = pg:
    if cfg.extraPlugins == [] then pg
    else pkgs.buildEnv {
      name = "postgresql-and-plugins-${(builtins.parseDrvName pg.name).version}";
      paths = [ pg ] ++ cfg.extraPlugins;
      postBuild =
        ''
          mkdir -p $out/bin
          rm $out/bin/{pg_config,postgres,pg_ctl}
          cp --target-directory=$out/bin ${pg}/bin/{postgres,pg_config,pg_ctl}
        '';
    };

  postgresql = postgresqlAndPlugins cfg.package;

  flags = optional cfg.enableTCPIP "-i";

  # The main PostgreSQL configuration file.
  configFile = pkgs.writeText "postgresql.conf"
    ''
      hba_file = '${pkgs.writeText "pg_hba.conf" cfg.authentication}'
      ident_file = '${pkgs.writeText "pg_ident.conf" cfg.identMap}'
      log_destination = 'stderr'
      port = ${toString cfg.port}
      ${cfg.extraConfig}
    '';

  pre84 = versionOlder (builtins.parseDrvName postgresql.name).version "8.4";

in

{

  ###### interface

  options = {

    services.postgresql = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run PostgreSQL.
        '';
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.postgresql92";
        description = ''
          PostgreSQL package to use.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5432;
        description = ''
          The port on which PostgreSQL listens.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = config.sal.dataContainerPaths.postgresql;
        description = ''
          Data directory for PostgreSQL.
        '';
      };

      authentication = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Defines how users authenticate themselves to the server. By
          default, "trust" access to local users will always be granted
          along with any other custom options. If you do not want this,
          set this option using "lib.mkForce" to override this
          behaviour.
        '';
      };

      identMap = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Defines the mapping from system users to database users.
        '';
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          A file containing SQL statements to execute on first startup.
        '';
      };

      enableTCPIP = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether PostgreSQL should listen on all network interfaces.
          If disabled, the database can only be accessed via its Unix
          domain socket or via TCP connections to localhost.
        '';
      };

      extraPlugins = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "pkgs.postgis";
        description = ''
          When this list contains elements a new store path is created.
          PostgreSQL and the elments are symlinked into it. Then pg_config,
          postgres and pc_ctl are copied to make them use the new
          $out/lib directory as pkglibdir. This makes it possible to use postgis
          without patching the .sql files which reference $libdir/postgis-1.5.
        '';
        # Note: the duplication of executables is about 4MB size.
        # So a nicer solution was patching postgresql to allow setting the
        # libdir explicitely.
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional text to be appended to <filename>postgresql.conf</filename>.";
      };

      recoveryConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Contents of the <filename>recovery.conf</filename> file.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.postgresql.enable {

    services.postgresql.authentication =
      ''
        # Generated file; do not edit!
        local all all              ident ${optionalString pre84 "sameuser"}
        host  all all 127.0.0.1/32 md5
        host  all all ::1/128      md5
      '';

    environment.systemPackages = [ postgresql ];

    sal.services.postgresql =
      { description = "PostgreSQL Server";

        platforms = platforms.unix;
        requires = {
          networking = true;
          dataContainers = [ "postgresql" ];
          ports = [ cfg.port ];
          dropPrivileges = pm.supports.privileged;
        };

        environment.PGDATA = cfg.dataDir;
        path = [ postgresql ];
        user = "postgres";
        group = "postgres";

        start.command = "${postgresql}/bin/postgres ${toString flags}";
        start.processName = "postgres";
        preStart.script =
          ''
            # Initialise the database.
            if ! test -e ${cfg.dataDir}/.db-created; then
              initdb ${optionalString (pm.supports.privileged) "-U root"}
              rm -f ${cfg.dataDir}/*.conf
              touch "${cfg.dataDir}"/{.db-created,.first-startup}
            fi

            ln -sfn "${configFile}" "${cfg.dataDir}/postgresql.conf"
            ${optionalString (cfg.recoveryConfig != null) ''
              ln -sfn "${pkgs.writeText "recovery.conf" cfg.recoveryConfig}" \
                "${cfg.dataDir}/recovery.conf"
            ''}
          '';

        # Wait for PostgreSQL to be ready to accept connections.
        postStart.script =
          ''
            while ! psql --port=${toString cfg.port} "postgres" -c "" 2> /dev/null; do
              if ! kill -0 "${"\$" + pm.envNames.mainPid}"; then exit 1; fi
              sleep 0.1
            done

            if test -e "${cfg.dataDir}/.first-startup"; then
              ${optionalString (cfg.initialScript != null) ''
                cat "${cfg.initialScript}" | psql --port=${toString cfg.port} "postgres"
              ''}
              rm -f "${cfg.dataDir}/.first-startup"
            fi
          '';
        postStart.privileged = pm.supports.privileged;

        # Give Postgres a decent amount of time to clean up after
        # receiving systemd's SIGINT.
        stop.timeout = 120;

        # Shut down Postgres using SIGINT ("Fast Shutdown mode").  See
        # http://www.postgresql.org/docs/current/static/server-shutdown.html
        stop.stopSignal = "INT";
        stop.stopMode = "mixed";
      };

    sal.dataContainers.postgresql = {
      description = "PostgreSQL data container";
      type = "db";
      mode = "0700";
      user = "postgres";
      group = "postgres";
    };

   users.extraUsers.postgres = {
     name = "postgres";
     uid = config.ids.uids.postgres;
     group = "postgres";
     description = "PostgreSQL server user";
   };

   users.extraGroups.postgres.gid = config.ids.gids.postgres;

  };

}
