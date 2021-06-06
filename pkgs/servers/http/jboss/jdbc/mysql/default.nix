{ lib, stdenv, mysql_jdbc }:

stdenv.mkDerivation {
  name = "jboss-mysql-jdbc";

  builder = ./builder.sh;

  inherit mysql_jdbc;

  meta = {
    platforms = lib.platforms.unix;
  };
}
