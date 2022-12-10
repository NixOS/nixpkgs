{ lib, stdenv, fetchurl, ant, unzip }:

stdenv.mkDerivation rec {
  pname = "mysql-connector-java";
  version = "8.0.31";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${version}.zip";
    sha256 = "sha256-Wo86n/4mono7YAagI/5Efm/X+2jjpOPaFSCMNAB6btI=";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp mysql-connector-j-*.jar $out/share/java/mysql-connector-j.jar
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ ant ];

  meta = with lib; {
    description = "MySQL Connector/J";
    homepage = "https://dev.mysql.com/doc/connector-j/8.0/en/";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
