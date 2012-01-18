{ stdenv, fetchurl_gnome, udev, polkit, dbus_glib, ppp, intltool, pkgconfig }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "ModemManager";
    major = "0"; minor = "5"; extension = "xz";
    sha256 = "0zvwrni4l21d856nq28khigrhwgrq5cc7nh45zidwjj8q7bsxiz7";
  };

  buildNativeInputs = [ intltool pkgconfig ];

  buildInputs = [ udev polkit dbus_glib ppp ];

  configureFlags = "--with-polkit --with-udev-base-dir=$(out)/lib/udev";

  meta = {
    description = "WWAN modem manager, part of NetworkManager";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
