{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnumake-3.80";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/make/make-3.80.tar.bz2;
    md5 = "0bbd1df101bc0294d440471e50feca71";
  };
  patches = [./log.diff];
}
