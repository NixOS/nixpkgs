{ stdenv, lib, kernel, udev, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "usbip-${kernel.name}";

  src = kernel.src;

  buildInputs = [ udev autoconf automake libtool ];

  preConfigure = ''
    cd tools/usb/usbip/
    ./autogen.sh
  '';

  meta = {
    homepage = https://github.com/torvalds/linux/tree/master/tools/usb/usbip;
    description = "allows to pass USB device from server to client over the network";
    license = lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
