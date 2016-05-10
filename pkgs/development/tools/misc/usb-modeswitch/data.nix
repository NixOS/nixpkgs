{ stdenv, fetchurl, pkgconfig, libusb1, usb-modeswitch }:

let
   version = "20160112";
in

stdenv.mkDerivation rec {
  name = "usb-modeswitch-data-${version}";

  src = fetchurl {
     url = "http://www.draisberghof.de/usb_modeswitch/${name}.tar.bz2";
     sha256 = "19yzqv0592b9mwgdi7apzw881q70ajyx5d56zr1z5ldi915a8yfn";
   };

  # make clean: we always build from source. It should be necessary on x86_64 only
  prePatch = ''
    sed -i 's@usb_modeswitch@${usb-modeswitch}/bin/usb_modeswitch@g' 40-usb_modeswitch.rules
    sed -i "1 i\DESTDIR=$out" Makefile
  '';

  buildInputs = [ pkgconfig libusb1 usb-modeswitch ];

  meta = {
    description = "device database and the rules file for 'multi-mode' USB devices";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
