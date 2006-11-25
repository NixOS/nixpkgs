{stdenv, fetchurl, perl, bison, mktemp}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "klibc-1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/libs/klibc/klibc-1.4.tar.bz2;
    md5 = "f4e0e17fc660e59c39e448fe1d827d36";
  };
  inherit (stdenv.glibc) kernelHeaders;
  buildInputs = [perl bison mktemp];
  patches = [./install.patch];
}
