{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name="dfu-util-${version}";
  version = "0.9";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  src = fetchurl {
    url = "http://dfu-util.sourceforge.net/releases/${name}.tar.gz";
    sha256 = "0czq73m92ngf30asdzrfkzraag95hlrr74imbanqq25kdim8qhin";
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
