{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-6.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/coreutils-6.3.tar.bz2;
    md5 = "065e9662c5aa2694693910ca9e6c9ec8";
  };
}
