{stdenv, fetchurl, pkgconfig, gtk, libusb, readline, lua, gtkdialog,
  python, ruby, libewf, vte, perl}:

stdenv.mkDerivation {
  name = "radare-1.3";

  src = fetchurl {
    url = http://radare.org/get/radare-1.3.tar.gz;
    sha256 = "0r2yl24ywyqzi7wn82hr6rkn3dgf9bl9m662hswszx44pd0cxarx";
  };

  patches = [ ./lua.patch ];

  buildInputs = [pkgconfig gtk readline libusb lua gtkdialog python
    ruby libewf vte perl];

  meta = {
    description = "Free advanced command line hexadecimal editor";
    homepage = http://radare.org/;
    license = "GPLv2+";
  };
}
