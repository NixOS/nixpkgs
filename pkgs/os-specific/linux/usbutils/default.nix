{stdenv, fetchurl, libusb}:

stdenv.mkDerivation {
  name = "usbutils-0.71";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/usbutils-0.71.tar.gz;
    md5 = "479d7c7098ef44cc95e7978fd71c712c";
  };
  buildInputs = [libusb];
}
