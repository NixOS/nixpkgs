{stdenv, fetchurl, patch}:

derivation {
  name = "gnumake-3.80";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/make/make-3.80.tar.bz2;
    md5 = "0bbd1df101bc0294d440471e50feca71";
  };
  patches = [./log.diff];
  buildInputs = [patch];
  inherit stdenv;
}
