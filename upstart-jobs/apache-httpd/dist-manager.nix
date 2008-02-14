{config, pkgs, serverInfo}:

let

  inherit (pkgs.lib) mkOption;

  urlPrefix = "/release";
  distDir = "/tmp/dist";
  distConfDir = "/tmp/dist-conf";

  staticFiles = substituteInAll {
    name = "svn-server-scripts";
    src = pkgs.lib.cleanSource ../../../services/dist-manager/files;

    perl = "${pkgs.perl}/bin/perl";

    inherit (serverInfo) canonicalName;

    inherit urlPrefix;

    defaultPath = ""; # !!!
    
    # Do a syntax check on the generated file.
    postInstall = ''
      $perl -c $out/cgi-bin/create-dist.pl # !!! should use -T
    '';
  };

  # !!! cut&paste
  substituteInAll = args: pkgs.stdenvUsingSetupNew2.mkDerivation ({
    buildCommand = ''
      ensureDir $out
      cp -prd $src/* $out
      chmod -R u+w $out
      find $out -type f -print | while read fn; do
        substituteAll $fn $fn
      done
      eval "$postInstall"
    '';
  } // args); # */

in {

  extraConfig = ''

    Alias ${urlPrefix}/css ${staticFiles}/css


    ScriptAlias ${urlPrefix}/cgi-bin ${staticFiles}/cgi-bin

    <Directory ${staticFiles}/cgi-bin>
        AllowOverride FileInfo AuthConfig Limit
        Options MultiViews SymLinksIfOwnerMatch ExecCGI
        SetHandler cgi-script

        # !!! this shouldn't be here
        Order allow,deny
        Allow from 131.211.0.0/255.255.0.0 # *.cs.uu.nl
        Allow from 130.145.0.0/255.255.0.0 # philips.com
        Allow from 130.161.158.181 # TUD supervisor
        Allow from 192.168.1.0/24 # TUD builders
        Allow from 127.0.0.1

        Require valid-user
        AuthType Basic
        AuthName "Nix Upload"
        AuthUserFile ${distConfDir}/upload_passwords
    </Directory>


    Alias ${urlPrefix} ${distDir}/

    <Location ${urlPrefix}>
        Options +Indexes

        RewriteEngine on
        RewriteRule ^${distDir}/(.*)/create-dist/(.*) ${urlPrefix}/cgi-bin/create-dist.pl/$1/$2

        AddType application/nix-package .nixpkg
    </Location>

    <Directory ${distDir}>
        AllowOverride FileInfo AuthConfig Limit
        Order allow,deny
        Allow from all
    </Directory>

  '';

  # !!! should not be needed
  extraModulesPre = [];
  extraModules = [];
  robotsEntries = "";
  globalEnvVars = [];
  extraServerPath = [];
  extraPath = [];

  options = {

  };  

}