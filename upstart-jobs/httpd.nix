{config, pkgs, glibc, extraConfig}:

let

  cfg = config.services.httpd;
  cfgSvn = cfg.subservices.subversion;

  optional = pkgs.lib.optional;

    
  documentRoot = cfg.documentRoot;
  hostName = cfg.hostName;
  httpPort = cfg.port;
  httpsPort = 443;
  user = cfg.user;
  group = cfg.group;
  adminAddr = cfg.adminAddr;
  logDir = cfg.logDir;
  stateDir = cfg.stateDir;
  enableSSL = false;
  applicationMappings = cfg.mod_jk.applicationMappings;
  
  startingDependency = if config.services.gw6c.enable && config.services.gw6c.autorun then "gw6c" else "network-interfaces";
  
  webServer = import ../../services/apache-httpd {
    inherit (pkgs) apacheHttpd coreutils;
    stdenv = pkgs.stdenv;
    php = if cfg.mod_php then pkgs.php else null;
    tomcat_connectors = if cfg.mod_jk.enable then pkgs.tomcat_connectors else null;

    inherit documentRoot hostName httpPort httpsPort
      user group adminAddr logDir stateDir
      applicationMappings;
    noUserDir = !cfg.enableUserDir;
    extraDirectories = extraConfig + "\n" + cfg.extraConfig;
    
    subServices =
    
      # The Subversion subservice.
      (optional cfgSvn.enable (
        let dataDir = cfgSvn.dataDir; in
        import ../../services/subversion ({
          reposDir = dataDir + "/repos";
          dbDir = dataDir + "/db";
          distsDir = dataDir + "/dist";
          backupsDir = dataDir + "/backup";
          tmpDir = dataDir + "/tmp";
          
          inherit user group logDir adminAddr;
          
          canonicalName =
            if webServer.enableSSL then
              "https://" + hostName + ":" + (toString httpsPort)
            else
              "http://" + hostName + ":" + (toString httpPort);

          notificationSender = cfgSvn.notificationSender;
          autoVersioning = cfgSvn.autoVersioning;
          userCreationDomain = cfgSvn.userCreationDomain;

          inherit pkgs;
        } //
          ( if cfgSvn.organization.name != null then
              {
                orgName = cfgSvn.organization.name;
                orgLogoFile = cfgSvn.organization.logo;
                orgUrl = cfgSvn.organization.url;
              }
            else
              # use the default from the subversion service
              {} 
          )
        )
        )
      )
      /* ++

      (optional cfg.extraSubservices.enable
        (map (service : service webServer pkgs) cfg.extraSubservices.services)
      ) */;
  };
  
in

{
  name = "httpd";
  
  users = [
    { name = user;
      description = "Apache httpd user";
    }
  ];

  groups = [
    { name = group;
    }
  ];
  
  job = "
description \"Apache HTTPD\"

start on ${startingDependency}/started
stop on ${startingDependency}/stop

start script
    ${webServer}/bin/control prepare    
end script

respawn ${webServer}/bin/control run
  ";
  
}
