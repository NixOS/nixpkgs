{stdenv, fetchurl, m4}:
assert !isNull m4;
derivation {
  name = "bison-1.875";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/bison/bison-1.875.tar.bz2;
    md5 = "b7f8027b249ebd4dd0cc948943a71af0";
  };
  stdenv = stdenv;
  m4 = m4;
}
