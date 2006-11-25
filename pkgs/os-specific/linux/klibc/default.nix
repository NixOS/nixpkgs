{stdenv, fetchurl, kernel, perl, bison, flexWrapper}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "klibc-1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/libs/klibc/klibc-1.4.tar.bz2;
    md5 = "f4e0e17fc660e59c39e448fe1d827d36";
  };
  inherit kernel;
#  buildInputs = [perl bison flexWrapper];
#  patches = [./klibc-installpath.patch];
}
