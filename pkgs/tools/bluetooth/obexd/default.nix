{ lib, stdenv, fetchurl, pkg-config, glib, dbus, openobex, bluez, libical }:

stdenv.mkDerivation rec {
  name = "obexd-0.48";

  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.bz2";
    sha256 = "1i20dnibvnq9lnkkhajr5xx3kxlwf9q5c4jm19kyb0q1klzgzlb8";
  };

  buildInputs = [ glib dbus openobex bluez libical ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "http://www.bluez.org/";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
