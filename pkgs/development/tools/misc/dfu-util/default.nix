{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name="dfu-util-${version}";
  version = "0.8";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dfu-util/dfu-util_0.8.orig.tar.gz";
    sha256 = "0n7h08avlzin04j93m6hkq9id6hxjiiix7ff9gc2n89aw6dxxjsm";
  };

  meta = with stdenv.lib; {
    description = "Device firmware update (DFU) USB programmer";
    longDescription = ''
      dfu-util is a program that implements the host (PC) side of the USB
      DFU 1.0 and 1.1 (Universal Serial Bus Device Firmware Upgrade) protocol.

      DFU is intended to download and upload firmware to devices connected over
      USB. It ranges from small devices like micro-controller boards up to mobile
      phones. With dfu-util you are able to download firmware to your device or
      upload firmware from it.
    '';
    homepage = http://dfu-util.gnumonks.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.fpletz ];
  };
}
