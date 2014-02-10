{ stdenv, fetchurl, udev, polkit, dbus_glib, ppp, intltool, pkgconfig, libmbim, libqmi }:

stdenv.mkDerivation rec {
  name = "ModemManager-0.7.991";

  src = fetchurl {
    url = "mirror://gnome/sources/ModemManager/0.7/${name}.tar.xz";
    sha256 = "0p8shqsbgnsazim7s52ylxjk064cbx2n1vm1jgywr7i58hsd6n4y";
  };

  nativeBuildInputs = [ intltool pkgconfig ];

  buildInputs = [ udev polkit dbus_glib ppp libmbim libqmi ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=$(out)/lib/udev"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  meta = {
    description = "WWAN modem manager, part of NetworkManager";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
