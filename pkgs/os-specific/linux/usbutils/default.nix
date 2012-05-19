{ stdenv, fetchurl, pkgconfig, libusb }:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://nixos.org/tarballs/usb.ids.20120411.bz2;
    sha256 = "0rgxancjd1krv9g817w1wlbg7k19i8mwx37qs1vw1f21xz49yvja";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-0.86";
  
  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.gz";
    sha256 = "1x0jkiwrgdb8qwy21iwhxpc8k61apxqp1901h866d1ydsakbxcmk";
  };
  
  buildInputs = [ pkgconfig libusb ];
  
  preBuild = "bunzip2 < ${usbids} > usb.ids";

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
