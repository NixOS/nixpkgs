{stdenv, fetchurl, pkgconfig, gtk, libusb, readline, lua, gtkdialog,
  python, ruby, libewf, vte, perl}:

stdenv.mkDerivation {
  name = "radare-1.4";

  src = fetchurl {
    url = http://radare.org/get/radare-1.4.tar.gz;
    sha256 = "1hx9xvcyvvbbbq39kkim3ajli1hqadld9vfzcxz7iz5pgp15mc3b";
  };

#  patches = [ ./lua.patch ];

  buildInputs = [pkgconfig gtk readline libusb lua gtkdialog python
    ruby libewf vte perl];

  meta = {
    description = "Free advanced command line hexadecimal editor";
    homepage = http://radare.org/;
    license = "GPLv2+";
  };
}
