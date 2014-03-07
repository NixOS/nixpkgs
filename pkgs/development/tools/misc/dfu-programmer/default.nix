{ stdenv, fetchurl, libusb1 }:
let
  version = "0.6.2";
in
stdenv.mkDerivation rec {
  name="dfu-programmer-${version}";

  buildInputs = [ libusb1 ];

  src = fetchurl {
    url = "mirror://sourceforge/dfu-programmer/${name}.tar.gz";
    sha256 = "0rdg4h5alpa3py3v3xgvn2vcgmnbj077am90jqj83nad89m9c801";
  };

  preConfigure = ''
    substituteInPlace configure \
     --replace "/usr/include/libusb-1.0" "${libusb1}/include/libusb-1.0"
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    description = "A Device Firmware Update based USB programmer for Atmel chips with a USB bootloader.";
    homepage = http://dfu-programmer.sourceforge.net/;
    maintainers = [ maintainers.the-kenny ];
  };
}
