{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "groff-1.19.1";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/groff/groff-1.19.1.tar.gz;
    md5 = "57d155378640c12a80642664dfdfc892";
  };
}
