{stdenv, fetchurl}: derivation {
  name = "ed-0.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnu.org/pub/gnu/ed/ed-0.2.tar.gz;
    md5 = "ddd57463774cae9b50e70cd51221281b";
  };
  stdenv = stdenv;
}
