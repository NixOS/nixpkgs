{stdenv, fetchurl, kernelHeaders, glibc}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "iputils-20020927";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.debian.org/debian/pool/main/i/iputils/iputils_20020927.orig.tar.gz;
    md5 = "b5493f7a2997130a4f86c486c9993b86";
  };

  inherit kernelHeaders glibc;
  patches = [ ./open-max.patch ];
}
