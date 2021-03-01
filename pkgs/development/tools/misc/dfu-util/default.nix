{ lib, stdenv, fetchurl, pkg-config, libusb1 }:

stdenv.mkDerivation rec {
  pname = "dfu-util";
  version = "0.10";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  src = fetchurl {
    url = "http://dfu-util.sourceforge.net/releases/${pname}-${version}.tar.gz";
    sha256 = "0hlvc47ccf5hry13saqhc1j5cdq5jyjv4i05kj0mdh3rzj6wagd0";
  };

  meta = with lib; {
    description = "Device firmware update (DFU) USB programmer";
    longDescription = ''
      dfu-util is a program that implements the host (PC) side of the USB
      DFU 1.0 and 1.1 (Universal Serial Bus Device Firmware Upgrade) protocol.

      DFU is intended to download and upload firmware to devices connected over
      USB. It ranges from small devices like micro-controller boards up to mobile
      phones. With dfu-util you are able to download firmware to your device or
      upload firmware from it.
    '';
    homepage = "http://dfu-util.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.fpletz ];
  };
}
