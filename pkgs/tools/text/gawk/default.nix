{stdenv, fetchurl}:

derivation {
  name = "gawk-3.1.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gawk/gawk-3.1.3.tar.bz2;
    md5 = "a116eec17e7ba085febb74c7758823bd";
  };
  inherit stdenv;
}
