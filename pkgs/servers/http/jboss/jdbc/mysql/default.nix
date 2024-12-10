{
  lib,
  stdenv,
  mysql_jdbc,
}:

stdenv.mkDerivation {
  pname = "jboss-mysql-jdbc";
  inherit (mysql_jdbc) version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/server/default/lib
    ln -s $mysql_jdbc/share/java/mysql-connector-java.jar $out/server/default/lib/mysql-connector-java.jar

    runHook postInstall
  '';

  meta = with lib; {
    inherit (mysql_jdbc.meta)
      description
      license
      platforms
      homepage
      ;
    maintainers = with maintainers; [ ];
  };
}
