{stdenv, fetchurl}:

derivation {
  name = "valgrind-2.1.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://developer.kde.org/~sewardj/valgrind-2.1.0.tar.bz2;
    md5 = "3e4056dd45163a5f555a23ced2f95191";
  };
  stdenv = stdenv;
}
