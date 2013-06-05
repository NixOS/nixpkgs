{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.25";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.25.zip;
    sha256 = "1qwnha8w8xafcig8wdvbry93pbli2vmzks8ds6kbb9im2k0rrmrw";
  };

  buildInputs = [ unzip ant ];
}
