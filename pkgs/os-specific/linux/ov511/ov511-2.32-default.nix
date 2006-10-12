{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "ov511-2.32";
  builder = ./ov511-2.32-builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ov511-2.32.tar.bz2;
    md5 = "6a08025311649356242761641a1df0f2";
  };
  patches = [./ov511-kernel.patch ./ov511-2.32.patch ./ov511-2.32-kdir.patch];
  inherit kernel;
  NIX_GLIBC_FLAGS_SET=1;
}
