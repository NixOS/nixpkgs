{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "net-tools-1.60";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/net-tools-1.60.tar.bz2;
    md5 = "888774accab40217dde927e21979c165";
  };
  config = ./config.h;
}
