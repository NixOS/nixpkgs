{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "ov511-2.30-${kernel.version}";
  builder = ./ov511-2.30-builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/ov511-2.30.tar.bz2;
    md5 = "9eacf9e54f2f54a59ddbf14221a53f2a";
  };
  patches = [./ov511-kernel.patch ./ov511-2.32-kdir.patch];
  inherit kernel;
  NIX_GLIBC_FLAGS_SET=1;
}
