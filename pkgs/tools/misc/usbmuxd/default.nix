{ stdenv, fetchurl, cmake, libplist, libusb1, pkgconfig }:

stdenv.mkDerivation rec {
  name = "usbmuxd-1.0.5";

  src = fetchurl {
    url = "http://marcansoft.com/uploads/usbmuxd/${name}.tar.bz2";
    sha256 = "130h5hk2qhki5xflcindx0prrgm5h7aqhbygrpasvr6030k6bkiv";
  };

  buildInputs = [ cmake pkgconfig ];
  propagatedBuildInputs = [ libusb1 libplist ];

  patchPhase = "sed -e 's,/lib/udev,lib/udev,' -i udev/CMakeLists.txt";

  cmakeFlags = ''-DLIB_SUFFIX='';
  meta = {
    homepage = http://marcansoft.com/blog/iphonelinux/usbmuxd/;
    description = "USB Multiplex Daemon (for talking to iPhone or iPod)";
    longDescription = ''
      usbmuxd: USB Multiplex Daemon. This bit of software is in charge of
      talking to your iPhone or iPod Touch over USB and coordinating access to
      its services by other applications.'';
    inherit (libusb1.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
