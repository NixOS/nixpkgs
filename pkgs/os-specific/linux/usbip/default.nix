{ lib, stdenv, kernel, udev, autoconf, automake, libtool }:

stdenv.mkDerivation {
  name = "usbip-${kernel.name}";

  src = kernel.src;

  patches = lib.optionals (lib.versionAtLeast "5.4" kernel.version) [
    # fixes build with gcc8
    ./fix-snprintf-truncation.patch
    # fixes build with gcc9
    ./fix-strncpy-truncation.patch
  ];

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ udev ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];

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
