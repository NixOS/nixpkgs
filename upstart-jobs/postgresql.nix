{pkgs, config}:

let

  cfg = config.services.postgresql;

  postgresql = pkgs.postgresql;

  startDependency = if config.services.gw6c.enable then 
    "gw6c" else "network-interfaces";

  run = "${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh postgres";

in

{
  name = "postgresql";

  users = [
    { name = "postgres";
      description = "PostgreSQL server user";
    }
  ];

  groups = [
    { name = "postgres"; }
  ];

  extraPath = [postgresql];

  job = ''
    description "PostgreSQL server"

    start on ${startDependency}/started
    stop on shutdown
    
    start script
        if ! test -e ${cfg.dataDir}; then
            mkdir -m 0700 -p ${cfg.dataDir}
            chown -R postgres ${cfg.dataDir}
            ${run} -c '${postgresql}/bin/initdb -D ${cfg.dataDir} -U root'
        fi
        cp -f ${pkgs.writeText "pg_hba.conf" cfg.authentication} ${cfg.dataDir}/pg_hba.conf
    end script

    respawn ${run} -c '${postgresql}/bin/postgres -D ${cfg.dataDir}'
  '';
}
