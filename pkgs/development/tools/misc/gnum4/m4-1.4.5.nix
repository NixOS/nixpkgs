{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.5";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/m4/m4-1.4.5.tar.bz2;
    md5 = "8bcd8244d5bed9f8e2d5f05ad693b8b4";
  };
}
