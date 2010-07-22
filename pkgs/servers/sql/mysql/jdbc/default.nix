{stdenv, fetchurl, ant}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.13";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://mirror.hostfuss.com/mysql/Downloads/Connector-J/mysql-connector-java-5.1.13.tar.gz;
    sha256 = "1y0x9a7d0qfn9bb2114v65407wnjwhz1ylxk0fn997gvwy43schi";
  };

  buildInputs = [ant];
}
