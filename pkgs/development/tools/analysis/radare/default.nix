{stdenv, fetchurl, pkgconfig, gtk, libusb, readline, lua, gtkdialog,
  python, ruby, libewf, vte, perl}:

stdenv.mkDerivation {
  name = "radare-1.2.2";

  src = fetchurl {
    url = http://radare.org/get/radare-1.2.2.tar.gz;
    sha256 = "0624ic97s1b70ijbr16b33p76mls8rziqwla6bq29l554dh2hfn4";
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
