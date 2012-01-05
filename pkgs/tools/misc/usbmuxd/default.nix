{ stdenv, fetchurl, cmake, libplist, libusb1, pkgconfig }:

stdenv.mkDerivation rec {
  name = "usbmuxd-1.0.7";

  src = fetchurl {
    url = "http://marcansoft.com/uploads/usbmuxd/${name}.tar.bz2";
    sha256 = "09swwr6x46qxmwylrylnyqh4pznr0swla9gijggwxxw8dw82r840";
  };

  buildNativeInputs = [ cmake pkgconfig ];
  propagatedBuildInputs = [ libusb1 libplist ];

  patchPhase =
    ''
    sed -e 's,/lib/udev,lib/udev,' -i udev/CMakeLists.txt
    sed -e 's,/bin/echo,echo,g' -i Modules/describe.sh
    '';


  cmakeFlags = ''-DLIB_SUFFIX='';
  meta = {
    homepage = http://marcansoft.com/blog/iphonelinux/usbmuxd/;
    description = "USB Multiplex Daemon (for talking to iPhone or iPod)";
    longDescription = ''
      usbmuxd: USB Multiplex Daemon. This bit of software is in charge of
      talking to your iPhone or iPod Touch over USB and coordinating access to
      its services by other applications.'';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
