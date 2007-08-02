{config, pkgs, glibc}:

let

  getCfg = option: config.get ["services" "httpd" option];
  getCfgs = options: config.get (["services" "httpd"] ++ options); 
  getCfgSvn = option: config.get ["services" "httpd" "subservices" "subversion" option];
  getCfgsSvn = options: config.get (["services" "httpd" "subservices" "subversion"] ++ options);

  optional = conf: subService:
    if conf then [subService] else [];

    
  hostName = getCfg "hostName";
  httpPort = getCfg "httpPort";
  httpsPort = getCfg "httpsPort";
  user = getCfg "user";
  group = getCfg "group";
  adminAddr = getCfg "adminAddr";
  logDir = getCfg "logDir";
  stateDir = getCfg "stateDir";
  enableSSL = false;
  noUserDir = getCfg "noUserDir";
  extraDirectories = getCfg "extraDirectories";

  startingDependency = if (config.get [ "services" "gw6c" "enable" ]) 
	then "gw6c" else "network-interfaces";
  
  webServer = import ../services/apache-httpd {
    inherit (pkgs) apacheHttpd coreutils;
    stdenv = pkgs.stdenvNewSetupScript;

    inherit hostName httpPort httpsPort
      user group adminAddr logDir stateDir
      noUserDir extraDirectories;
    
    subServices =
    
      # The Subversion subservice.
      (optional (getCfgSvn "enable") (
        let dataDir = getCfgSvn "dataDir"; in
        import ../services/subversion ({
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

          notificationSender = getCfgSvn "notificationSender";
          autoVersioning = getCfgSvn "autoVersioning";
          userCreationDomain = getCfgSvn "userCreationDomain";

          inherit pkgs;
        } //
          ( if getCfgsSvn ["organization" "name"] != null then
              {
                orgName = getCfgsSvn ["organization" "name"];
                orgLogoFile = getCfgsSvn ["organization" "logo"];
                orgUrl = getCfgsSvn ["organization" "url"];
              }
            else
              # use the default from the subversion service
              {} 
          )
        )
        )
      )
      ++

      (optional (getCfgs ["extraSubservices" "enable"])
        (map (service : service webServer pkgs)
          (getCfgs ["extraSubservices" "services"])
        )
      )
      ;
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
