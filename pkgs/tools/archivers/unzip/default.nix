{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unzip-5.50";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/unzip550.tar.gz;
    md5 = "798592d62e37f92571184236947122ed";
  };
}
