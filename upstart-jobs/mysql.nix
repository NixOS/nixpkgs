{pkgs, config}:

let

  cfg = config.services.mysql;

  mysql = pkgs.mysql;

  pidFile = "${cfg.pidDir}/mysqld.pid";

  mysqldOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} " +
    "--log-error=${cfg.logError} --pid-file=${pidFile}";

in

{
  name = "mysql";
  
  users = [
    { name = "mysql";
      description = "MySQL server user";
    }
  ];

  extraPath = [mysql];
  
  job = ''
    description "MySQL server"

    stop on shutdown

    start script
        if ! test -e ${cfg.dataDir}; then
            mkdir -m 0700 -p ${cfg.dataDir}
            chown -R ${cfg.user} ${cfg.dataDir}
            ${mysql}/bin/mysql_install_db ${mysqldOptions}
        fi

        mkdir -m 0700 -p ${cfg.pidDir}
        chown -R ${cfg.user} ${cfg.pidDir}
    end script

    respawn ${mysql}/bin/mysqld ${mysqldOptions}

    stop script
        pid=$(cat ${pidFile})
        kill "$pid"
        ${mysql}/bin/mysql_waitpid "$pid" 1000
    end script
  '';
}
