{ stdenv, fetchurl, libplist, libusb1, pkgconfig, libimobiledevice }:

stdenv.mkDerivation rec {
  name = "usbmuxd-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://www.libimobiledevice.org/downloads/${name}.tar.bz2";
    sha256 = "0bdlc7a8plvglqqx39qqampqm6y0hcdws76l9dffwl22zss4i29y";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libusb1 libplist libimobiledevice ];

  preConfigure = ''
    configureFlags="$configureFlags --with-udevrulesdir=$out/lib/udev/rules.d"
    configureFlags="$configureFlags --with-systemdsystemunitdir=$out/lib/systemd/system"
  '';

  meta = {
    homepage = http://marcansoft.com/blog/iphonelinux/usbmuxd/;
    description = "USB Multiplex Daemon (for talking to iPhone or iPod)";
    longDescription = ''
      usbmuxd: USB Multiplex Daemon. This bit of software is in charge of
      talking to your iPhone or iPod Touch over USB and coordinating access to
      its services by other applications.'';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
