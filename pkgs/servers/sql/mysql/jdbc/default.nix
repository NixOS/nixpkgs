{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.31";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.31.zip;
    sha256 = "1j6jvpadlib2hb6n3kh7s9ygjyqvi5gawrmnk1dsvvdcbkk1v871";
  };

  buildInputs = [ unzip ant ];
}
