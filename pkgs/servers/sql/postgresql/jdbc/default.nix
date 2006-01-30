{stdenv, fetchurl, ant}:

stdenv.mkDerivation {
  name = "postgresql-jdbc-8.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/postgresql-jdbc-8.0-311.src.tar.gz;
    md5 = "e31b6e68141883e5c89a3a9b0fb95c02";
  };

  buildInputs = [ant];
}
