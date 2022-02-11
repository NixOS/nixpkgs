{ lib, stdenv, fetchurl, ant, unzip }:

stdenv.mkDerivation rec {
  pname = "mysql-connector-java";
  version = "5.1.49";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${version}.zip";
    sha256 = "1bm4mm4xka4pq2rwxx3k8xlcpa1vjcglr3pf4ls2i4hamww047yk";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp mysql-connector-java-*-bin.jar $out/share/java/mysql-connector-java.jar
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
