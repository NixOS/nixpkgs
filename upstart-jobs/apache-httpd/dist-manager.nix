{config, pkgs, serverInfo}:

let

  inherit (pkgs.lib) mkOption;
  inherit (config) urlPrefix distDir;
  
  staticFiles = substituteInAll {
    name = "dist-manager-files";
    src = pkgs.lib.cleanSource ../../../services/dist-manager/files;

    perl = "${pkgs.perl}/bin/perl";

    inherit (serverInfo) canonicalName;

    inherit urlPrefix;

    directoriesConf = pkgs.writeText "directories.conf" config.directoriesConf;

    defaultPath = "${pkgs.coreutils}/bin:${pkgs.findutils}/bin";

    saxon8 = pkgs.saxonb;

    logFile = "${serverInfo.serverConfig.logDir}/release";

    # Do a syntax check on the generated file.
    postInstall = ''
      $perl -c $out/cgi-bin/create-dist.pl # !!! should use -T
    '';
  };

  # !!! cut&paste
  substituteInAll = args: pkgs.stdenv.mkDerivation ({
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
        Options SymLinksIfOwnerMatch ExecCGI
        SetHandler cgi-script

        Order allow,deny
        ${pkgs.lib.concatMapStrings (ip: "Allow from ${ip}\n") config.uploaderIPs}

        Require valid-user
        AuthType Basic
        AuthName "Nix Upload"
        AuthUserFile ${config.distPasswords}
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
  startupScript = null;

  options = {

    urlPrefix = mkOption {
      default = "/dist";
      description = ''
        The URL prefix under which the release pages appear.
      '';
    };

    distDir = mkOption {
      example = "/data/dist";
      description = ''
        Path to the top-level release directory.
      '';
    };

    distPasswords = mkOption {
      example = "/data/dist-passwords";
      description = ''
        Location of the password file for the uploading of releases.
      '';
    };

    uploaderIPs = mkOption {
      default = [];
      example = ["127.0.0.1" "192.168.1.0/255.255.255.0"];
      description = ''
        IP address or address ranges of the machines that are allowed to upload releases.
      '';
    };

    directoriesConf = mkOption {
      example = ''
        fnord /data/dist/fnord fnord-upload
      '';
      description = ''
        The per-project release directories, with each line containing
        the project name, the corresponding release directory, and the
        users that can upload to that directory.
      '';
    };

  };  

}