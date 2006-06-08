{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.2.0";
  src = fetchurl {
    url = http://www.valgrind.org/downloads/valgrind-3.2.0.tar.bz2;
    md5 = "c418026ce7c38a740ef17efe59509fcf";
  };
}
