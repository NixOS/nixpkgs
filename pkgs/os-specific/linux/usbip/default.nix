{ stdenv, kernel, udev, autoconf, automake, libtool }:

stdenv.mkDerivation {
  name = "usbip-${kernel.name}";

  src = kernel.src;

  patches = [
    # fixes build with gcc8
    ./fix-snprintf-truncation.patch
  ];

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
