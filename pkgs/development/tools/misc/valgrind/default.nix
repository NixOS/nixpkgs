{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.2.2";
  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.2.2.tar.bz2;
    md5 = "de3f68da0c8b7fc72b8fded95a9aebbc";
  };

  meta = {
    description = "Award-winning suite of tools for debugging and profiling Linux programs";
  };
}
