{ lib, stdenv, fetchurl, ant, unzip }:

stdenv.mkDerivation rec {
  pname = "mysql-connector-java";
  version = "8.1.0";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${version}.zip";
    sha256 = "sha256-xFYvNbb5cj6xrMHAnTzGLC8v5fxqRcmZhf4haK3wtUk=";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp mysql-connector-j-*.jar $out/share/java/mysql-connector-j.jar
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ ant ];

  meta = with lib; {
    description = "MySQL Connector/J";
    homepage = "https://dev.mysql.com/doc/connector-j/8.1/en/";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
