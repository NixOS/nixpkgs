{ stdenv, fetchurl, pkgconfig, libusb1 }:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://tarballs.nixos.org/usb.ids.20120920.bz2;
    sha256 = "0sz860g7grf6kx22p49s6j8h85c69ymcw16a8110klzfl9hl9hli";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-007";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "197gpbxnspy6ncqv5mziaikcfqgb3irbqqlfwjgzvh5v4hbs14vm";
  };

  buildInputs = [ pkgconfig libusb1 ];

  # currently up-to-date
  #preBuild = "bunzip2 < ${usbids} > usb.ids";

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
