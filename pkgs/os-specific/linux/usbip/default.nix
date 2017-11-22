{ stdenv, kernel, udev, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "usbip-${kernel.name}";

  src = kernel.src;

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ udev ];

  preConfigure = ''
    cd tools/usb/usbip
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/torvalds/linux/tree/master/tools/usb/usbip;
    description = "allows to pass USB device from server to client over the network";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
