{lib, stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation rec {
  name = "mysql-connector-java-5.1.46";

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-J/${name}.zip";
    sha256 = "0dfjshrrx0ndfb6xbdpwhn1f1jkw0km57rgpar0ny8ixmgdnlwnm";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ ant ];

  unpackPhase = ''
    unzip $src
    cd mysql-connector-java-*
  '';

  installPhase = ''
    mkdir -p $out/share/java
    cp mysql-connector-java-*-bin.jar $out/share/java/mysql-connector-java.jar
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
