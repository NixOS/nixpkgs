{
  lib,
  stdenv,
  fetchurl,
  ant,
  unzip,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "mysql-connector-java";
  version = "8.3.0";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${version}.zip";
    hash = "sha256-w2xddRQMjSTEprB9pmK8zKskGtthNuUd9YBPaMym7WE=";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp mysql-connector-j-*.jar $out/share/java/mysql-connector-j.jar
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ ant ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/mysql/mysql-connector-j.git";
  };

  meta = with lib; {
    description = "MySQL Connector/J";
    homepage = "https://dev.mysql.com/doc/connector-j/en/";
    changelog = "https://dev.mysql.com/doc/relnotes/connector-j/en/";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.gpl2;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
