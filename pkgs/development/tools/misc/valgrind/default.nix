{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.2.3";
  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.2.3.tar.bz2;
    sha256 = "0hf48y13mm1c1zg59bvkbr0lzcwng5mb33lgiv3d0gzl4w2r5jhv";
  };

  meta = {
    description = "Award-winning suite of tools for debugging and profiling Linux programs";
  };
}
