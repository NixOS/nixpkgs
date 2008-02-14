{config, pkgs, serverInfo}:

let

  inherit (pkgs.lib) mkOption;

  urlPrefix = "/release";
  distDir = "/tmp/dist";
  distPasswords = "/tmp/dist-conf/upload_passwords";

  directoriesConf = pkgs.writeText "directories.conf" ''
    nix          ${distDir}/nix          nix-upload
    nix-cache    ${distDir}/nix-cache    nix-upload stratego-upload autobundle-upload swe-upload meta-environment-upload hut-upload
    test         ${distDir}/test         test-upload nix-upload
    test-cache   ${distDir}/test-cache   test-upload nix-upload
    stratego     ${distDir}/stratego     stratego-upload
    autobundle   ${distDir}/autobundle   autobundle-upload
    courses      ${distDir}/courses      swe-upload
    meta-environment ${distDir}/meta-environment meta-environment-upload
    hut          ${distDir}/hut          hut-upload
  '';

  uploaderIPs = [
    "127.0.0.1"
    "10.0.0.0/255.0.0.0"
    "131.211.0.0/255.255.0.0" # *.cs.uu.nl
    "130.145.0.0/255.255.0.0" # philips.com
    "130.161.158.181" # TUD supervisor
  ];

  staticFiles = substituteInAll {
    name = "dist-manager-files";
    src = pkgs.lib.cleanSource ../../../services/dist-manager/files;

    perl = "${pkgs.perl}/bin/perl";

    inherit (serverInfo) canonicalName;

    inherit urlPrefix directoriesConf;

    defaultPath = "${pkgs.coreutils}/bin:${pkgs.findutils}/bin";

    saxon8 = pkgs.saxonb;

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
        Options SymLinksIfOwnerMatch ExecCGI
        SetHandler cgi-script

        Order allow,deny
        ${pkgs.lib.concatMapStrings (ip: "Allow from ${ip}\n") uploaderIPs}

        Require valid-user
        AuthType Basic
        AuthName "Nix Upload"
        AuthUserFile ${distPasswords}
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