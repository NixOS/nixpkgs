{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.15";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/binutils-2.15.tar.bz2;
    md5 = "624e6b74983ac6b2960edaf2d522ca58";
  };
  patches = [./no-lex.patch];
  inherit noSysDirs;
}
