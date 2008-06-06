{config, pkgs}:

let

  stateDir = "/var/run/zabbix";

  logDir = "/var/log/zabbix";

  libDir = "/var/lib/zabbix";

  pidFile = "${stateDir}/zabbix_server.pid";

  configFile = pkgs.writeText "zabbix_server.conf" ''
    LogFile = ${logDir}/zabbix_server
  
    DebugLevel = 4

    PidFile = ${pidFile}

    DBName = zabbix

    DBUser = zabbix
  '';

in

{
  name = "zabbix-server";
  
  users = [
    { name = "zabbix";
      uid = (import ../system/ids.nix).uids.zabbix;
      description = "Zabbix daemon user";
    }
  ];

  job = ''
    description "Zabbix server daemon"

    start on postgresql/started
    stop on shutdown

    start script
      mkdir -m 0755 -p ${stateDir} ${logDir} ${libDir}
      chown zabbix ${stateDir} ${logDir} ${libDir}

      if ! test -e "${libDir}/db-created"; then
          ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole zabbix || true
          ${pkgs.postgresql}/bin/createdb --owner zabbix zabbix || true
          cat ${pkgs.zabbixServer}/share/zabbix/db/schema/postgresql.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c 'psql zabbix'
          cat ${pkgs.zabbixServer}/share/zabbix/db/data/data.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c 'psql zabbix'
          cat ${pkgs.zabbixServer}/share/zabbix/db/data/images_pgsql.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c 'psql zabbix'
          touch "${libDir}/db-created"
      fi
      
      export PATH=${pkgs.nettools}/bin:$PATH
      ${pkgs.zabbixServer}/sbin/zabbix_server --config ${configFile}
    end script

    respawn sleep 100000
    
    stop script
      while ${pkgs.procps}/bin/pkill -u zabbix zabbix_server; do true; done
    end script
  '';
  
}
