{stdenv, fetchurl, ant}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.14";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.14.tar.gz/from/http://mirror.leaseweb.com/mysql/;
    sha256 = "1l1jgaf498pvmvls3ilwyxpcafywfabf5kjc8qgzx7559lx8fvya";
  };

  buildInputs = [ant];
}
