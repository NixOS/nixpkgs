{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation rec {
  name = "mysql-connector-java-5.1.39";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-J/${name}.zip";
    sha256 = "0d0g51hfx7a2r6nbni8yramg4vpqk0sql0aaib6q576a0nnrq78r";
  };

  buildInputs = [ unzip ant ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
