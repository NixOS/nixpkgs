{ stdenv, jboss, mysql_jdbc }:

stdenv.mkDerivation {
  name = "jboss-mysql-jdbc";

  builder = ./builder.sh;

  inherit mysql_jdbc;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
