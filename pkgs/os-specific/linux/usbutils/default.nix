{ stdenv, fetchurl, pkgconfig, libusb1, hwdata }:

stdenv.mkDerivation rec {
  name = "usbutils-010";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "06aag4jfgsfjxk563xsp9ik9nadihmasrr37a1gb0vwqni5kdiv1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  postInstall =
    ''
      substituteInPlace $out/bin/lsusb.py \
        --replace /usr/share/usb.ids ${hwdata}/data/hwdata/usb.ids
    '';

  meta = with stdenv.lib; {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
