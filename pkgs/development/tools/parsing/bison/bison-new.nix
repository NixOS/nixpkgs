{stdenv, fetchurl, m4}:

assert !isNull m4;

derivation {
  name = "bison-1.875c";
  system = stdenv.system;
  builder = ./builder-new.sh;
  src = fetchurl {
    url = ftp://alpha.gnu.org/pub/gnu/bison/bison-1.875c.tar.gz;
    md5 = "bba317725fc84013b9d0a6b2576dfaa7";
  };
  stdenv = stdenv;
  m4 = m4;
}
