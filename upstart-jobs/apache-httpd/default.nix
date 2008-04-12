{config, pkgs}:

let

  cfg = config.services.httpd;

  mainCfg = cfg;
  
  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";

  httpd = pkgs.apacheHttpd;

  inherit (pkgs.lib) addDefaultOptionValues optional concatMap concatMapStrings;
  

  makeServerInfo = cfg: {
    # Canonical name must not include a trailing slash.
    canonicalName =
      "http://${cfg.hostName}" +
      (if cfg.httpPort != 80 then ":${toString cfg.httpPort}" else "");

    # Admin address: inherit from the main server if not specified for
    # a virtual host.
    adminAddr = if cfg.adminAddr != "" then cfg.adminAddr else mainCfg.adminAddr;

    vhostConfig = cfg;
    serverConfig = mainCfg;
    fullConfig = config; # machine config
  };


  vhostOptions = import ./per-server-options.nix {
    inherit (pkgs.lib) mkOption;
    forMainServer = false;
  };

  vhosts = let
    makeVirtualHost = cfgIn: 
      let
        # Fill in defaults for missing options.
        cfg = addDefaultOptionValues vhostOptions cfgIn;
      in cfg;
    in map makeVirtualHost cfg.virtualHosts;


  callSubservices = serverInfo: defs:
    let f = svc:
      let config = addDefaultOptionValues res.options svc.config;
          res = svc.function {inherit config pkgs serverInfo;};
      in res;
    in map f defs;


  # !!! callSubservices is expensive   
  subservicesFor = cfg: callSubservices (makeServerInfo cfg) cfg.extraSubservices;

  mainSubservices = subservicesFor mainCfg;

  allSubservices = mainSubservices ++ pkgs.lib.concatMap subservicesFor vhosts;

  sslServerCert = cfg.sslServerCert;
  sslServerKey = cfg.sslServerKey;

  # !!! should be in lib
  writeTextInDir = name: text:
    pkgs.runCommand name {inherit text;} "ensureDir $out; echo -n \"$text\" > $out/$name";
  

  # Names of modules from ${httpd}/modules that we want to load.
  apacheModules = 
    [ # HTTP authentication mechanisms: basic and digest.
      "auth_basic" "auth_digest"

      # Authentication: is the user who he claims to be?
      "authn_file" "authn_dbm" "authn_anon" "authn_alias"

      # Authorization: is the user allowed access?
      "authz_user" "authz_groupfile" "authz_host"

      # Other modules.
      "ext_filter" "include" "log_config" "env" "mime_magic"
      "cern_meta" "expires" "headers" "usertrack" /* "unique_id" */ "setenvif"
      "mime" "dav" "status" "autoindex" "asis" "info" "cgi" "dav_fs"
      "vhost_alias" "negotiation" "dir" "imagemap" "actions" "speling"
      "userdir" "alias" "rewrite" "proxy" "proxy_http"
    ] ++ optional cfg.enableSSL "ssl";
    

  loggingConf = ''
    ErrorLog ${cfg.logDir}/error_log

    LogLevel notice

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    LogFormat "%{Referer}i -> %U" referer
    LogFormat "%{User-agent}i" agent

    CustomLog ${cfg.logDir}/access_log common
  '';


  browserHacks = ''
    BrowserMatch "Mozilla/2" nokeepalive
    BrowserMatch "MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0
    BrowserMatch "RealPlayer 4\.0" force-response-1.0
    BrowserMatch "Java/1\.0" force-response-1.0
    BrowserMatch "JDK/1\.0" force-response-1.0
    BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
    BrowserMatch "^WebDrive" redirect-carefully
    BrowserMatch "^WebDAVFS/1.[012]" redirect-carefully
    BrowserMatch "^gnome-vfs" redirect-carefully
  '';


  # !!! integrate with virtual hosting below
  sslConf = ''
    Listen ${toString cfg.httpsPort}

    SSLSessionCache dbm:${cfg.stateDir}/ssl_scache

    SSLMutex file:${cfg.stateDir}/ssl_mutex

    SSLRandomSeed startup builtin
    SSLRandomSeed connect builtin

    <VirtualHost _default_:${toString cfg.httpsPort}>

        SSLEngine on

        SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL

        SSLCertificateFile ${sslServerCert}
        SSLCertificateKeyFile ${sslServerKey}

        #   MSIE compatability.
        SetEnvIf User-Agent ".*MSIE.*" \
                 nokeepalive ssl-unclean-shutdown \
                 downgrade-1.0 force-response-1.0

    </VirtualHost>
  '';


  mimeConf = ''
    TypesConfig ${httpd}/conf/mime.types

    AddType application/x-x509-ca-cert .crt
    AddType application/x-pkcs7-crl    .crl
    AddType application/x-httpd-php    .php .phtml

    <IfModule mod_mime_magic.c>
        MIMEMagicFile ${httpd}/conf/magic
    </IfModule>

    AddEncoding x-compress Z
    AddEncoding x-gzip gz tgz
  '';


  perServerConf = isMainServer: cfg: let

    serverInfo = makeServerInfo cfg;

    subservices = callSubservices serverInfo cfg.extraSubservices;

    documentRoot = if cfg.documentRoot != null then cfg.documentRoot else
      pkgs.runCommand "empty" {} "ensureDir $out";

    documentRootConf = ''
      DocumentRoot "${documentRoot}"

      <Directory "${documentRoot}">
          Options Indexes FollowSymLinks
          AllowOverride None
          Order allow,deny
          Allow from all
      </Directory>
    '';

    robotsTxt = pkgs.writeText "robots.txt" ''
      ${# If this is a vhost, the include the entries for the main server as well.
        if isMainServer then ""
        else concatMapStrings (svc: svc.robotsEntries) mainSubservices}
      ${concatMapStrings (svc: svc.robotsEntries) subservices}
    '';

    robotsConf = ''
      Alias /robots.txt ${robotsTxt}
    '';

  in ''
    ServerName ${serverInfo.canonicalName}

    ${concatMapStrings (alias: "ServerAlias ${alias}\n") cfg.serverAliases}

    ${if isMainServer || cfg.adminAddr != "" then ''
      ServerAdmin ${cfg.adminAddr}
    '' else ""}

    ${if !isMainServer && mainCfg.logPerVirtualHost then ''
      ErrorLog ${mainCfg.logDir}/error_log-${cfg.hostName}
      CustomLog ${mainCfg.logDir}/access_log-${cfg.hostName} common
    '' else ""}

    ${robotsConf}

    ${if isMainServer || cfg.documentRoot != null then documentRootConf else ""}

    ${
      let makeDirConf = elem: ''
            Alias ${elem.urlPath} ${elem.dir}/
            <Directory ${elem.dir}>
                Order allow,deny
                Allow from all
                AllowOverride None
            </Directory>
          '';
      in concatMapStrings makeDirConf cfg.servedDirs
    }

    ${
      let makeFileConf = elem: ''
            Alias ${elem.urlPath} ${elem.file}
          '';
      in concatMapStrings makeFileConf cfg.servedFiles
    }

    ${concatMapStrings (svc: svc.extraConfig) subservices}

    ${cfg.extraConfig}
  '';

  
  httpdConf = pkgs.writeText "httpd.conf" ''
  
    ServerRoot ${httpd}

    PidFile ${cfg.stateDir}/httpd.pid

    <IfModule prefork.c>
        MaxClients           150
        MaxRequestsPerChild  0
    </IfModule>

    Listen ${toString cfg.httpPort}

    User ${cfg.user}
    Group ${cfg.group}

    ${let
        load = {name, path}: "LoadModule ${name}_module ${path}\n";
        allModules =
          concatMap (svc: svc.extraModulesPre) allSubservices ++
          map (name: {inherit name; path = "${httpd}/modules/mod_${name}.so";}) apacheModules ++
          concatMap (svc: svc.extraModules) allSubservices;
      in concatMapStrings load allModules
    }

    ${if cfg.enableUserDir then ''
    
      UserDir public_html
      UserDir disabled root
      
      <Directory "/home/*/public_html">
          AllowOverride FileInfo AuthConfig Limit Indexes
          Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
          <Limit GET POST OPTIONS>
              Order allow,deny
              Allow from all
          </Limit>
          <LimitExcept GET POST OPTIONS>
              Order deny,allow
              Deny from all
          </LimitExcept>
      </Directory>
      
    '' else ""}

    AddHandler type-map var

    <Files ~ "^\.ht">
        Order allow,deny
        Deny from all
    </Files>

    ${mimeConf}
    ${loggingConf}
    ${browserHacks}

    Include ${httpd}/conf/extra/httpd-default.conf
    Include ${httpd}/conf/extra/httpd-autoindex.conf
    Include ${httpd}/conf/extra/httpd-multilang-errordoc.conf
    Include ${httpd}/conf/extra/httpd-languages.conf
    
    ${if cfg.enableSSL then sslConf else ""}

    # Fascist default - deny access to everything.
    <Directory />
        Options FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
    </Directory>

    # But do allow access to files in the store so that we don't have
    # to generate <Directory> clauses for every generated file that we
    # want to serve.
    <Directory /nix/store>
        Order allow,deny
        Allow from all
    </Directory>

    # Generate directives for the main server.
    ${perServerConf true cfg}
    
    # Always enable virtual hosts; it doesn't seem to hurt.
    NameVirtualHost *:*

    ${let
        makeVirtualHost = cfg: ''
          <VirtualHost *:*>
              ${perServerConf false cfg}
          </VirtualHost>
        '';
      in concatMapStrings makeVirtualHost vhosts}
  '';

    
in

{

  name = "httpd";
  
  users = [
    { name = cfg.user;
      description = "Apache httpd user";
    }
  ];

  groups = [
    { name = cfg.group;
    }
  ];

  extraPath = [httpd] ++ concatMap (svc: svc.extraPath) allSubservices;

  # Statically verify the syntactic correctness of the generated
  # httpd.conf.
  buildHook = ''
    echo
    echo '=== Checking the generated Apache configuration file ==='
    ${httpd}/bin/httpd -f ${httpdConf} -t
  '';

  job = ''
    description "Apache HTTPD"

    start on ${startingDependency}/started
    stop on shutdown

    start script
      mkdir -m 0700 -p ${cfg.stateDir}
      mkdir -m 0700 -p ${cfg.logDir}

      # Get rid of old semaphores.  These tend to accumulate across
      # server restarts, eventually preventing it from restarting
      # succesfully.
      for i in $(${pkgs.utillinux}/bin/ipcs -s | grep ' ${cfg.user} ' | cut -f2 -d ' '); do
          ${pkgs.utillinux}/bin/ipcrm -s $i
      done

      # Run the startup hooks for the subservices.
      for i in ${toString (map (svn: svn.startupScript) allSubservices)}; do
          echo Running Apache startup hook $i...
          $i
      done
    end script

    ${
      let f = {name, value}: "env ${name}=${value}\n";
      in concatMapStrings f (pkgs.lib.concatMap (svc: svc.globalEnvVars) allSubservices)
    }

    env PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.lib.concatStringsSep ":" (pkgs.lib.concatMap (svc: svc.extraServerPath) allSubservices)}

    ${pkgs.diffutils}/bin:${pkgs.gnused}/bin

    respawn ${httpd}/bin/httpd -f ${httpdConf} -DNO_DETACH
  '';

}
