{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.14";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/tar/tar-1.14.tar.bz2;
    md5 = "f1932e0fbd4641885bfdcc75495c91b7";
  };
}
