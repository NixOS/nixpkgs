{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mingetty-1.07";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mingetty_1.07.orig.tar.gz;
    md5 = "491dedf1ceff0e0f5f7bb9f55bf5213e";
  };
  patches = [./makefile.patch];
}
