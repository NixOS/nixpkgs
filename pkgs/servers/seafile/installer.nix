{ stdenv, fetchurl, seafile-server, buildEnv, pythonPackages, python, ccnet4
, libsearpc, writeScriptBin, procps, destination ? "/var/lib/seafile"
, serverName ? "haiwen" }:
let
  helptxt = builtins.toFile "help.txt" ''
    First time and on update:
    $ nix-env -iA pkgs.seafile-server-installer
    $ seafile-server-install
    if updating, check which update scripts you will have to run:
    http://manual.seafile.com/deploy/upgrade.html

    First time only (interactive setup):
    $ seafile-server-env seafile-admin setup

    To run (you will need Nginx or something to serve, otherwise use without `--fastcgi`):
    $ seafile-server-env seafile-admin start --fastcgi

    First time, after starting server (interactive creation of admin user):
    $ seafile-server-env seafile-admin create-admin
  '';

  seahubSrc = fetchurl {
    url = https://github.com/haiwen/seahub/archive/v4.0.0-pro.tar.gz;
    sha256 = "1m7xbnczvp1npykvcby3inkvl6vqalzcvj8ksymjqkkrxpi6cmda";
  };

  deps = buildEnv {
    name = "deps";
    paths = with pythonPackages; [ python.modules.sqlite3 pillow
      django_1_5 djblets seafile-server ccnet4 libsearpc gunicorn
      six flup chardet dateutil ];
  };

  install = writeScriptBin "seafile-server-install" ''
    set -e
    set -x
    mkdir -p ${destination}/${serverName}/seafile-server
    cd ${destination}/${serverName}/seafile-server
    test -d ./seahub && rm -rf ./seahub
    mkdir ./seahub
    tar xf ${seahubSrc} -C ./seahub --strip-components=1;
  '';

  env = writeScriptBin "seafile-server-env" ''
    cd ${destination}/${serverName}
    export PATH="${procps}/bin:${deps}/bin:${python}/bin"
    export PYTHONPATH="${deps}/${python.sitePackages}:${destination}/${serverName}/seafile-server/seahub:${destination}/${serverName}/seafile-server/seahub/thirdpart"
    export SEAFILE_TOPDIR="${destination}/${serverName}"

    "$@"
  '';

  help = writeScriptBin "seafile-server-help" ''
    cat ${helptxt}
  '';

in buildEnv {
  name = "seafile-server-installer";
  paths = [ install env help ];
}
