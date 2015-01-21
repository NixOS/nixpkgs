{ stdenv, fetchurl, libusb }:
let
  version = "0.7.1";
in
stdenv.mkDerivation rec {
  name="dfu-programmer-${version}";

  buildInputs = [ libusb ];

  src = fetchurl {
    url = "mirror://sourceforge/dfu-programmer/${name}.tar.gz";
    sha256 = "0cwy7z5h6f13yx9bkgh61bphzii6lcl21j2gckskphf37bfzazwz";
  };

  configureFlags = [ "--disable-libusb_1_0" ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    description = "A Device Firmware Update based USB programmer for Atmel chips with a USB bootloader";
    homepage = http://dfu-programmer.sourceforge.net/;
    maintainers = [ maintainers.the-kenny ];
  };
}
