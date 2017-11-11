{ stdenv, fetchurl, pkgconfig, libusb1, hwdata }:

stdenv.mkDerivation rec {
  name = "usbutils-008";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "132clk14j4nm8crln2jymdbbc2vhzar2j2hnxyh05m79pbq1lx24";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  postInstall =
    ''
      substituteInPlace $out/bin/lsusb.py \
        --replace /usr/share/usb.ids ${hwdata}/data/hwdata/usb.ids
    '';

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
    platforms = stdenv.lib.platforms.linux;
  };
}
