{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "zdelta-2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/zdelta-2.1.tar.gz;
    md5 = "c69583a64f42f69a39e297d0d27d77e5";
  };
}
