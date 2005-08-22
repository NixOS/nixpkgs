{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gawk-3.1.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gawk-3.1.4.tar.bz2;
    md5 = "b8b532beaf02350e69d2d5dc98cb1e37";
  };
}
