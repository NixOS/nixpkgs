{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.38";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.zip;
    sha256 = "0b1j2dylnpk6b17gn3168qdrrwq8kdil57nxrd08n1lnkirdsx33";
  };

  buildInputs = [ unzip ant ];
}
