{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "ed-0.4";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/ed/ed-0.4.tar.bz2;
    md5 = "b5c8606bb306671bbbb2bd708d937bcb";
  };
}
