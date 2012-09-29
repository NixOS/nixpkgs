{ stdenv, fetchurl, pkgconfig, libusb1 }:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://nixos.org/tarballs/usb.ids.20120920.bz2;
    sha256 = "0sz860g7grf6kx22p49s6j8h85c69ymcw16a8110klzfl9hl9hli";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-006";

  src = fetchurl {
    url = mirror://kernel/linux/utils/usb/usbutils/usbutils-006.tar.xz;
    sha256 = "03pd57vv8c6x0hgjqcbrxnzi14h8hcghmapg89p8k5zpwpkvbdfr";
  };

  buildInputs = [ pkgconfig libusb1 ];

  preBuild = "bunzip2 < ${usbids} > usb.ids";

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
