{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-5.2.1";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/coreutils/coreutils-5.2.1.tar.bz2;
    md5 = "172ee3c315af93d3385ddfbeb843c53f";
  };
}
