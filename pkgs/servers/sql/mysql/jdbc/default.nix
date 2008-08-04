{stdenv, fetchurl, ant}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://mirror.hostfuss.com/mysql/Downloads/Connector-J/mysql-connector-java-5.1.6.tar.gz;
    md5 = "84641aa4ddc138fc400366021f05cec5";
  };

  buildInputs = [ant];
}
