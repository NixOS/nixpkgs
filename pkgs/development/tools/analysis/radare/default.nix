{stdenv, fetchurl, pkgconfig, gtk, libusb, readline, lua, gtkdialog,
  python, ruby, libewf, vte, perl}:

stdenv.mkDerivation {
  name = "radare-1.4.1";

  src = fetchurl {
    url = http://radare.org/get/radare-1.4.1.tar.gz;
    sha256 = "1q5hajhvp7nfyrj83gk7x6cbg520nvg39wbyq21bfncxk28rkmxh";
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
