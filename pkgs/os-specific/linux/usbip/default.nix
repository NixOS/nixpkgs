{ lib, stdenv, fetchpatch, kernel, udev, autoconf, automake, libtool, hwdata, kernelOlder }:

stdenv.mkDerivation {
  name = "usbip-${kernel.name}";

  src = kernel.src;

  patches = lib.optionals (kernelOlder "5.4") [
    # fixes build with gcc8
    ./fix-snprintf-truncation.patch
    # fixes build with gcc9
    ./fix-strncpy-truncation.patch
  ] ++ kernel.patches;

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ udev ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];

  preConfigure = ''
    cd tools/usb/usbip
    ./autogen.sh
  '';

  configureFlags = [ "--with-usbids-dir=${hwdata}/share/hwdata/" ];

  meta = with lib; {
    homepage = "https://github.com/torvalds/linux/tree/master/tools/usb/usbip";
    description = "allows to pass USB device from server to client over the network";
    license = with licenses; [ gpl2Only gpl2Plus ];
    platforms = platforms.linux;
    broken = kernelOlder "4.10";
  };
}
