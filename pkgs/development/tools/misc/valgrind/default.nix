{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.1.1";
  src = fetchurl {
    url = http://www.valgrind.org/downloads/valgrind-3.1.1.tar.bz2;
    md5 = "3bbfafedb59c19bf75977381ce2eb6d7";
  };
}
