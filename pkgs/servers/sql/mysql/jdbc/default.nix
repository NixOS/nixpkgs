{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.17";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://mirror.leaseweb.com/mysql/Downloads/Connector-J/mysql-connector-java-5.1.17.zip;
    sha256 = "1c4hsx0qwb3rp66a1dllnah2zi9gqqnr4aqm9p59yrqj5jr22ldp";
  };

  buildInputs = [ unzip ant ];
}
