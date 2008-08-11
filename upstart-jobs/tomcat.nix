args: with args;

let
  cfg = config.services.tomcat;
in

{
  name = "tomcat";
  
  groups = [
    { name = "tomcat";
      gid = (import ../system/ids.nix).gids.tomcat;
    }
  ];
  
  users = [
    { name = "tomcat";
      uid = (import ../system/ids.nix).uids.tomcat;
      description = "Tomcat user";
      home = "/homeless-shelter";
    }
  ];
  
  job = ''
    description "Apache Tomcat server"

    start on network-interface/started
    stop on network-interfaces/stop
    
    start script
        # Create initial state data
        
        if ! test -d ${cfg.baseDir}
        then    
            mkdir -p ${cfg.baseDir}/webapps
            mkdir -p ${cfg.baseDir}/shared
	    mkdir -p ${cfg.baseDir}/lib
            cp -av ${pkgs.tomcat6}/{conf,temp,logs} ${cfg.baseDir}
        fi
        
	# Deploy context.xml
	
	if test "${cfg.contextXML}" = ""
	then
	    cp ${pkgs.tomcat6}/conf/context.xml.default ${cfg.baseDir}/conf/context.xml
	else
	    cp ${cfg.contextXML} ${cfg.baseDir}/conf/context.xml
	fi
		
        # Deploy all webapplications
        
        if ! test "${cfg.deployFrom}" = ""
        then
            rm -rf ${cfg.baseDir}/webapps
            mkdir -p ${cfg.baseDir}/webapps
            for i in ${cfg.deployFrom}/*
            do
                cp -rL $i ${cfg.baseDir}/webapps
            done
        fi
	
        # Fix permissions
        
        chown -R ${cfg.user} ${cfg.baseDir}
        
        for i in `find ${cfg.baseDir} -type d`
        do
            chmod -v 755 $i
        done
        
        for i in `find ${cfg.baseDir} -type f`
        do
            chmod -v 644 $i
        done

	# Deploy all common libraries
		
	rm -rf ${cfg.baseDir}/lib/*
	
	if test "${cfg.commonLibFrom}" = ""
	then
	    commonLibFrom="${pkgs.tomcat6}/lib";
	else
	    commonLibFrom="${cfg.commonLibFrom}";
	fi
	
	for i in $commonLibFrom/*.jar
	do
	    ln -s $i ${cfg.baseDir}/lib
	done

        # Deploy all shared libraries
        
        if ! test "${cfg.sharedLibFrom}" = ""
        then
            rm -f ${cfg.baseDir}/shared/lib
            ln -s ${cfg.sharedLibFrom} ${cfg.baseDir}/shared/lib
        fi

    end script
    
    respawn ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh ${cfg.user} -c 'CATALINA_BASE=${cfg.baseDir} JAVA_HOME=${pkgs.jdk} JAVA_OPTS="${cfg.javaOpts}" CATALINA_OPTS="${cfg.catalinaOpts}" ${pkgs.tomcat6}/bin/startup.sh; sleep 1d'
    
    stop script
        echo "Stopping tomcat..."
        CATALINA_BASE=${cfg.baseDir} JAVA_HOME=${pkgs.jdk} ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh ${cfg.user} -c ${pkgs.tomcat6}/bin/shutdown.sh
    end script
  '';
}
