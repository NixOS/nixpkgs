{ lib, stdenv, mysql_jdbc }:

stdenv.mkDerivation {
  name = "jboss-mysql-jdbc";

  buildInputs = [ mysql_jdbc ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/server/default/lib
    ln -s ${mysql_jdbc}/share/java/mysql-connector-java.jar $out/server/default/lib/mysql-connector-java.jar
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
