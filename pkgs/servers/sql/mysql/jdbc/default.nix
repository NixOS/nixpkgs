{lib, stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation rec {
  pname = "mysql-connector-java";
  version = "5.1.46";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-J/${pname}-${version}.zip";
    sha256 = "0dfjshrrx0ndfb6xbdpwhn1f1jkw0km57rgpar0ny8ixmgdnlwnm";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ ant ];

  meta = {
    platforms = lib.platforms.unix;
  };
}
