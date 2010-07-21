{ stdenv, fetchurl, pkgconfig, libusb }:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://nixos.org/tarballs/usb.ids.20100720.bz2;
    sha256 = "0krncssk0b10z6grw305824zma953l3g2rb7jkk25mb78pw5fd5d";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-0.86";
  
  src = fetchurl {
    url = "mirror://sourceforge/linux-usb/${name}.tar.gz";
    sha256 = "1x0jkiwrgdb8qwy21iwhxpc8k61apxqp1901h866d1ydsakbxcmk";
  };
  
  buildInputs = [ pkgconfig libusb ];
  
  preBuild = "bunzip2 < ${usbids} > usb.ids";

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
