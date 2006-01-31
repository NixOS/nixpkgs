{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.1.0";
  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.1.0.tar.bz2;
    md5 = "d92156e9172dc6097e56c69ea9c88013";
  };
}
