{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation rec {
  name = "mysql-connector-java-5.1.46";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-J/${name}.zip";
    sha256 = "0dfjshrrx0ndfb6xbdpwhn1f1jkw0km57rgpar0ny8ixmgdnlwnm";
  };

  buildInputs = [ unzip ant ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
