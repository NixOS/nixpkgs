{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-2.1.0";
  src = fetchurl {
    url = http://developer.kde.org/~sewardj/valgrind-2.1.0.tar.bz2;
    md5 = "3e4056dd45163a5f555a23ced2f95191";
#    url = http://developer.kde.org/~sewardj/valgrind-2.1.1.tar.bz2;
#    md5 = "0010c3e8f054ecc633151c62044b646d";
  };
}
