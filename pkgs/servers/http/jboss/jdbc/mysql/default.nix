{ lib, stdenv, mysql_jdbc }:

stdenv.mkDerivation {
  pname = "jboss-mysql-jdbc";

  builder = ./builder.sh;

  inherit mysql_jdbc;
  version = mysql_jdbc.version;

  meta = {
    platforms = lib.platforms.unix;
  };
}
