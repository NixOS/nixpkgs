{ stdenv, fetchurl, libusb }:
let
  version = "0.7.2";
in
stdenv.mkDerivation rec {
  name="dfu-programmer-${version}";

  buildInputs = [ libusb ];

  src = fetchurl {
    url = "mirror://sourceforge/dfu-programmer/${name}.tar.gz";
    sha256 = "15gr99y1z9vbvhrkd25zqhnzhg6zjmaam3vfjzf2mazd39mx7d0x";
  };

  configureFlags = [ "--disable-libusb_1_0" ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    description = "A Device Firmware Update based USB programmer for Atmel chips with a USB bootloader";
    homepage = http://dfu-programmer.sourceforge.net/;
    maintainers = [ maintainers.the-kenny ];
    platforms = platforms.linux;
  };
}
