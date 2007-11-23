{config, pkgs}:

let

  nagiosUser = "nagios";
  nagiosGroup = "nogroup";

  nagiosState = "/var/lib/nagios";
  nagiosLogDir = "/var/log/nagios";

  nagiosObjectDefs = [
    ./timeperiods.cfg
    ./host-templates.cfg
    ./service-templates.cfg
    ./commands.cfg
  ] ++ config.services.nagios.objectDefs;

  nagiosObjectDefsDir = pkgs.runCommand "nagios-objects" {inherit nagiosObjectDefs;}
    "ensureDir $out; ln -s $nagiosObjectDefs $out/";

  nagiosCfgFile = pkgs.writeText "nagios.cfg" "
  
    # Paths for state and logs.
    log_file=${nagiosLogDir}/current
    log_archive_path=${nagiosLogDir}/archive
    status_file=${nagiosState}/status.dat
    object_cache_file=${nagiosState}/objects.cache
    comment_file=${nagiosState}/comment.dat
    downtime_file=${nagiosState}/downtime.dat
    temp_file=${nagiosState}/nagios.tmp
    lock_file=/var/run/nagios.lock # Not used I think.
    state_retention_file=${nagiosState}/retention.dat

    # Configuration files.
    #resource_file=resource.cfg
    cfg_dir=${nagiosObjectDefsDir}

    # Uid/gid that the daemon runs under.
    nagios_user=${nagiosUser}
    nagios_group=${nagiosGroup}

    # Misc. options.
    illegal_macro_output_chars=`~$&|'\"<>
    retain_state_information=1
    
  ";

  # Plain configuration for the Nagios web-interface with no
  # authentication.
  nagiosCGICfgFile = pkgs.writeText "nagios.cgi.conf" "
    main_config_file=${nagiosCfgFile}
    use_authentication=0
    url_html_path=/nagios
  ";

  urlPath = config.services.nagios.urlPath;

  extraHttpdConfig = "
    ScriptAlias ${urlPath}/cgi-bin ${pkgs.nagios}/sbin

    <Directory \"${pkgs.nagios}/sbin\">
      Options ExecCGI
      AllowOverride None
      Order allow,deny
      Allow from all
      SetEnv NAGIOS_CGI_CONFIG ${nagiosCGICfgFile}
    </Directory>

    Alias ${urlPath} ${pkgs.nagios}/share

    <Directory \"${pkgs.nagios}/share\">
      Options None
      AllowOverride None
      Order allow,deny
      Allow from all
    </Directory>
  ";
    
in

{
  name = "nagios";
  
  users = [
    { name = nagiosUser;
      uid = (import ../../system/ids.nix).uids.nagios;
      description = "Nagios monitoring daemon";
      home = nagiosState;
    }
  ];

  extraPath = [pkgs.nagios];

  # This isn't needed, it's just so that the user can type "nagiostats
  # -c /etc/nagios.cfg".
  extraEtc = [
    { source = nagiosCfgFile;
      target = "nagios.cfg";
    }
  ];

  extraHttpdConfig =
    if config.services.nagios.enableWebInterface then extraHttpdConfig else "";
  
  # Run `nagios -v' to check the validity of the configuration file so
  # that a nixos-rebuild fails *before* we kill the running Nagios
  # daemon.
  buildHook = "${pkgs.nagios}/bin/nagios -v ${nagiosCfgFile}";

  job = "
    description \"Nagios monitoring daemon\"

    start on network-interfaces/started
    stop on network-interfaces/stop

    start script
      mkdir -m 0755 -p ${nagiosState} ${nagiosLogDir}
      chown ${nagiosUser} ${nagiosState} ${nagiosLogDir}
    end script

    respawn

    script
      for i in ${toString config.services.nagios.plugins}; do
        export PATH=$i/bin:$i/sbin:$i/libexec:$PATH
      done
      exec ${pkgs.nagios}/bin/nagios ${nagiosCfgFile}
    end script
  ";
  
}
