{ stdenv, fetchurl_gnome, udev, polkit, dbus_glib, ppp, intltool, pkgconfig }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "ModemManager";
    major = "0"; minor = "5"; patchlevel = "4.0"; extension = "xz";
    sha256 = "1fdf5d5cc494825afe9f551248e00a2d91e220e88435b47f109ca2a707a40f1f";
  };

  nativeBuildInputs = [ intltool pkgconfig ];

  buildInputs = [ udev polkit dbus_glib ppp ];

  configureFlags = "--with-polkit --with-udev-base-dir=$(out)/lib/udev";

  meta = {
    description = "WWAN modem manager, part of NetworkManager";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
