{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.0.1";
  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.0.1.tar.bz2;
    md5 = "c29efdb7d1a93440f5644a6769054681";
  };
}
