{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-6.7";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/coreutils/coreutils-6.7.tar.bz2;
    md5 = "a16465d0856cd011a1acc1c21040b7f4";
  };
}
