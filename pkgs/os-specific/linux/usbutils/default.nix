{ stdenv, fetchurl, pkgconfig, libusb1, hwdata }:

stdenv.mkDerivation rec {
  name = "usbutils-009";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "0q3iavmak2bs9xw486w4xfbjl0hbzii93ssgpr95mxmm9kjz1gwb";
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
