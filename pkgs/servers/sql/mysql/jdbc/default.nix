{stdenv, fetchurl, ant}:

stdenv.mkDerivation {
  name = "mysql-connector-java-3.1.12";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mysql-connector-java-3.1.12.tar.gz;
    md5 = "c8c15443dfa9541545aad02d744a077b";
  };

  buildInputs = [ant];
}
