{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-5.94";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/coreutils/coreutils-5.94.tar.bz2;
    md5 = "11985c8345371546da8ff13f7efae359";
  };
}
