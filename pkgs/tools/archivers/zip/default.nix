{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "zip-2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/zip23.tar.gz;
    md5 = "5206a99541f3b0ab90f1baa167392c4f";
  };
}
