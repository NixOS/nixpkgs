{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.32";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.32.zip;
    sha256 = "11vjwws1pa8fdwn86rrmqdwsq3ld3sh2r0pp4lpr2gxw0w18ykc7";
  };

  buildInputs = [ unzip ant ];
}
