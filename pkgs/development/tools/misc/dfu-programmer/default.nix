{ stdenv, fetchurl, libusb }:
let
  version = "0.7.0";
in
stdenv.mkDerivation rec {
  name="dfu-programmer-${version}";

  buildInputs = [ libusb ];

  src = fetchurl {
    url = "mirror://sourceforge/dfu-programmer/${name}.tar.gz";
    sha256 = "17lglglk5xrqd2n0impg5bkq4j96qc51cw3kzcghzmzmn6fvg3gf";
  };

  configureFlags = [ "--disable-libusb_1_0" ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    description = "A Device Firmware Update based USB programmer for Atmel chips with a USB bootloader.";
    homepage = http://dfu-programmer.sourceforge.net/;
    maintainers = [ maintainers.the-kenny ];
  };
}
