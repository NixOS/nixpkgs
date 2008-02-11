{ config, pkgs, serverInfo
}:

let

  prefix = "/svn";
  dbDir = "/tmp/svn/db";
  reposDir = "/tmp/svn/repos";
  backupsDir = "/tmp/svn/backup";
  tmpDir = "/tmp/svn/tmp";
  adminAddr = "eelco@cs.uu.nl";
  userCreationDomain = "10.0.0.0/8";


  # Build a Subversion instance with Apache modules and Swig/Python bindings.
  subversion = import ../../../nixpkgs/pkgs/applications/version-management/subversion-1.4.x {
    inherit (pkgs) fetchurl stdenv apr aprutil neon expat swig zlib;
    bdbSupport = true;
    httpServer = true;
    sslSupport = true;
    compressionSupport = true;
    pythonBindings = true;
    httpd = pkgs.apacheHttpd;
  };

  
  # Build our custom authentication modules.
  authModules = import ../../../services/subversion/src/auth {
    inherit (pkgs) stdenv apacheHttpd;
  };


  commonAuth = ''
    AuthType Basic
    AuthName "Subversion repositories"
    AuthBasicProvider auth-against-db
  '';
  

  # Access controls for /repos and /repos-xml. 
  reposConfig = dirName: ''
    ${commonAuth}

    AuthAllowNone on

    AuthzRepoPrefix ${prefix}/${dirName}/
    AuthzRepoDBType DB
    AuthzRepoReaders ${dbDir}/svn-readers
    AuthzRepoWriters ${dbDir}/svn-writers

    <LimitExcept GET PROPFIND OPTIONS REPORT>
        Require repo-writer
    </LimitExcept>

    <Limit GET PROPFIND OPTIONS REPORT>
        Require repo-reader
    </Limit>

    DAV svn
    SVNParentPath ${reposDir}
    #SVNAutoversioning @autoVersioning@
  '';


  # Build ViewVC.
  viewvc = import ../../../services/subversion/src/viewvc {
    inherit (pkgs) fetchurl stdenv python enscript;
    inherit reposDir adminAddr subversion;
    urlPrefix = prefix;
  };


  viewerConfig = dirName: ''
    ${commonAuth}
    AuthAllowNone on
    AuthzRepoPrefix ${prefix}/${dirName}/
    AuthzRepoDBType DB
    AuthzRepoReaders ${dbDir}/svn-readers
    Require repo-reader
  '';


  viewvcConfig = ''
    ScriptAlias ${prefix}/viewvc ${viewvc}/viewvc/bin/mod_python/viewvc.py

    <Location ${prefix}/viewvc>
        AddHandler python-program .py
        # Note: we write \" instead of ' to work around a lexer bug in Nix 0.11.
        PythonPath "[\"${viewvc}/viewvc/bin/mod_python\", \"${subversion}/lib/python2.4/site-packages\"] + sys.path"
        PythonHandler handler
        ${viewerConfig "viewvc"}
    </Location>

    Alias ${prefix}/viewvc-doc ${viewvc}/viewvc/templates/docroot

    Redirect permanent ${prefix}/viewcvs ${serverInfo.canonicalName}/${prefix}/viewvc
  '';


  # Build WebSVN.
  websvn = import ../../../services/subversion/src/websvn {
    inherit (pkgs) fetchurl stdenv writeText enscript gnused diffutils;
    inherit reposDir subversion;
    cacheDir = tmpDir;
    urlPrefix = prefix;
  };

  
  websvnConfig = ''
    Alias ${prefix}/websvn ${websvn}/wsvn.php
    Alias ${prefix}/templates ${websvn}/templates

    <Location ${prefix}/websvn>
        ${viewerConfig "websvn"}
    </Location>

    <Directory ${websvn}/templates>
        Order allow,deny
        Allow from all
    </Directory>
  '';


  # Build Repoman.
    
  repoman = pkgs.substituteAll {
    src = ../../../services/subversion/src/repoman/repoman.pl.in;
    dir = "/";
    name = "repoman.pl";
    isExecutable = true;
    perl = "${pkgs.perl}/bin/perl";
    defaultPath = "";
    urlPrefix = prefix;
    orgUrl = "http://example.org/";
    orgLogoUrl = "http://example.org/";
    orgName = "Example Org";
    inherit (serverInfo) canonicalName;
    fsType = "fsfs";
    inherit adminAddr reposDir backupsDir dbDir subversion userCreationDomain;

    # Urgh, most of these are dependencies of Email::Send, should figure them out automatically.
    perlFlags = "-I${pkgs.perlBerkeleyDB}/lib/site_perl -I${pkgs.perlEmailSend}/lib/site_perl -I${pkgs.perlEmailSimple}/lib/site_perl -I${pkgs.perlModulePluggable}/lib/site_perl -I${pkgs.perlReturnValue}/lib/site_perl -I${pkgs.perlEmailAddress}/lib/site_perl";
  };

  repomanConfig = ''
    ScriptAlias ${prefix}/repoman ${repoman}/repoman.pl

    <Location ${prefix}/repoman/listdetails>
        ${commonAuth}    
        Require valid-user
    </Location>

    <Location ${prefix}/repoman/adduser>
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from ${userCreationDomain}
    </Location>

    <Location ${prefix}/repoman/edituser>
        ${commonAuth}    
        Require valid-user
    </Location>

    <Location ${prefix}/repoman/create>
        ${commonAuth}    
        Require valid-user
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from ${userCreationDomain}
    </Location>

    <Location ${prefix}/repoman/update>
        ${commonAuth}    
        Require valid-user
    </Location>

    <Location ${prefix}/repoman/dump>
        ${viewerConfig "repoman/dump"}
    </Location>
  '';

  
  # !!!
  writeTextInDir = name: text:
    pkgs.runCommand name {inherit text;} "ensureDir $out; echo -n \"$text\" > $out/$name";
    
in

{

  extraModulesPre = [
    # Allow anonymous access to repositories that are world-readable
    # without prompting for a username/password.
    { name = "authn_noauth"; path = "${authModules}/modules/mod_authn_noauth.so"; }
    # Check whether the user is allowed read or write access to a
    # repository.
    { name = "authz_dyn";    path = "${authModules}/modules/mod_authz_dyn.so"; }
  ];

  extraModules = [
    { name = "python";  path = "${pkgs.mod_python}/modules/mod_python.so"; }
    { name = "php5";    path = "${pkgs.php}/modules/libphp5.so"; }
    { name = "dav_svn"; path = "${subversion}/modules/mod_dav_svn.so"; }
  ];

  extraConfig = ''
  
    <AuthnProviderAlias dbm auth-against-db>
        AuthDBMType DB
        AuthDBMUserFile ${dbDir}/svn-users
    </AuthnProviderAlias>

    <Location ${prefix}/repos>
      ${reposConfig "repos"}
    </Location>
    
    <Location ${prefix}/repos-xml>
      ${reposConfig "repos-xml"}
      SVNIndexXSLT "${prefix}/xsl/svnindex.xsl"
    </Location>

    ${viewvcConfig}

    ${websvnConfig}

    ${repomanConfig}
        
  '';

  robotsEntries = ''
    User-agent: *
    Disallow: ${prefix}/viewcvs/
    Disallow: ${prefix}/viewvc/
    Disallow: ${prefix}/websvn/
    Disallow: ${prefix}/repos-xml/
  '';

  # mod_python's own Python modules must be in the initial Python
  # path, they cannot be set through the PythonPath directive.
  globalEnvVars = [
    { name = "PYTHONPATH"; value = "${pkgs.mod_python}/lib/python2.4/site-packages"; }
  ];

  extraPath = [
    # Needed for ViewVC.
    "${pkgs.diffutils}/bin"
    "${pkgs.gnused}/bin"
  ];
  
}
