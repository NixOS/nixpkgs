{ stdenv
, nodejs
, fetchzip
, utillinux
, runCommand
, callPackage
}:

# Configuration
{ port ? "2368"
, url
, host ? "127.0.0.1"
, contentPath
, databaseClient ? "mysql"

# For mysql
, mysqlHost ? "127.0.0.1"
, mysqlUser ? "root"
, mysqlPassword ? ""
, mysqlDatabase ? "ghost"
, mysqlCharset ? "utf8"

# For sqlite
,  sqliteFilename ? "" }:

let
  ghost = import ./default.nix;
  client =
    if stdenv.lib.any (c: c == databaseClient) ["mysql" "sqlite3"]
    then databaseClient
    else throw "databaseClient has to be either mysql or sqlite3";
in
  ghost {
    inherit stdenv nodejs fetchzip utillinux runCommand callPackage;

    postConfigure = ''
      echo $ghostConfig > config.js
    '';

    ghostConfig = ''
      var config = {
        production: {
          url: '${url}',
          mail: {},
          database: {
            client: '${client}',
            connection: {
              host     : '${mysqlHost}',
              user     : '${mysqlUser}',
              password : '${mysqlPassword}',
              database : '${mysqlDatabase}',
              charset  : '${mysqlCharset}',
              filename : '${sqliteFilename}'
            },
            debug: false
          },
          server: {
            host: '${host}',
            port: '${port}'
          },
          paths: {
            contentPath: '${contentPath}',
          },
        },
      };
      module.exports = config;
    '';
  }
