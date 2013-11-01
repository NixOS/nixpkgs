{ stdenv, fetchurl, pkgconfig, libusb1 }:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://tarballs.nixos.org/usb.ids.20130821.bz2;
    sha256 = "0x7mf4h5h5wjzhygfr4lc8yz0cwm7mahxrnp5nkxcmawmyxwsg53";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-007";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "197gpbxnspy6ncqv5mziaikcfqgb3irbqqlfwjgzvh5v4hbs14vm";
  };

  buildInputs = [ pkgconfig libusb1 ];

  preBuild = "bunzip2 < ${usbids} > usb.ids";

  postInstall =
    ''
      rm $out/sbin/update-usbids.sh
      substituteInPlace $out/bin/lsusb.py \
        --replace /usr/share/usb.ids $out/share/usb.ids
    '';

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
