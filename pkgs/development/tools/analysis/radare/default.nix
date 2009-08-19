{stdenv, fetchurl, pkgconfig, gtk, libusb, readline, lua, gtkdialog,
  python, ruby, libewf, vte, perl}:

stdenv.mkDerivation {
  name = "radare-1.4.2";

  src = fetchurl {
    url = http://radare.org/get/radare-1.4.2.tar.gz;
    sha256 = "09pai3k4x3kzq7zjfd8425jjb16fpximrhp5wyy6pwgdc82q30sd";
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
