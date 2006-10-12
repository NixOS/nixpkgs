{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.2.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/valgrind-3.2.1.tar.bz2;
    md5 = "9407d33961186814cef0e6ecedfd6318";
  };

  meta = {
    description = "Award-winning suite of tools for debugging and profiling Linux programs";
  };
}
