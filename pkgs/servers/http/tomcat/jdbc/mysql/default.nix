{ lib, stdenv, mysql_jdbc }:

stdenv.mkDerivation {
  pname = "tomcat-mysql-jdbc";
  version = mysql_jdbc.version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    ln -s $mysql_jdbc/share/java/mysql-connector-java.jar $out/lib/mysql-connector-java.jar

    runHook postInstall
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
