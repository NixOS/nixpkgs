{ stdenv, fetchurl, pkgconfig, libusb1, zlib, autoreconfHook }:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://nixos.org/tarballs/usb.ids.20120411.bz2;
    sha256 = "0rgxancjd1krv9g817w1wlbg7k19i8mwx37qs1vw1f21xz49yvja";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-005";
  
  src = fetchurl {
    url = mirror://debian/pool/main/u/usbutils/usbutils_005.orig.tar.gz;
    sha256 = "05sxkm7b7lj8p8kr8kw68m49h66351s803z42233b8lssmc3wlra";
  };
  
  buildInputs = [ pkgconfig libusb1 autoreconfHook ];

  preConfigure = "autoreconf -i";
  
  preBuild = "bunzip2 < ${usbids} > usb.ids";

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
