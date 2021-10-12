{ lib, stdenv, mysql_jdbc }:

stdenv.mkDerivation {
  pname = "tomcat-mysql-jdbc";
  builder = ./builder.sh;
  buildInputs = [ mysql_jdbc ];

  inherit mysql_jdbc;
  version = mysql_jdbc.version;

  meta = {
    platforms = lib.platforms.unix;
  };
}
