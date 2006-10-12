{stdenv, fetchurl, kernel, gawk}:

stdenv.mkDerivation {
  name = "qc-usb-0.6.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/qc-usb-0.6.4.tar.gz;
    md5 = "7e91c3a633382c99100e3ef4f1d9f50a";
  };
  inherit kernel;
  buildInputs = [gawk];
  patches = [./quickcam-install.patch];
}
