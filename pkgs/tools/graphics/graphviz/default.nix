{stdenv, fetchurl, x11, libpng, libjpeg, expat}:

assert !isNull x11 && !isNull libpng && !isNull libjpeg
  && !isNull expat;

derivation {
  name = "graphviz-1.10";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-1.10.tar.gz;
    md5 = "e1402531abff68d146bf94e72b44dc2a";
  };

  stdenv = stdenv;
  x11 = x11;
  libpng = libpng;
  libjpeg = libjpeg;
  expat = expat;
}
