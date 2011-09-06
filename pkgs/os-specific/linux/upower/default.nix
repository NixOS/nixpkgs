{ stdenv, fetchurl, xz, pkgconfig, glib, dbus, dbus_glib, polkit
, intltool, libxslt, docbook_xsl, udev, libusb1, pmutils }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.9.13";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "08jasjkp44ydvsnk020xghrshi0jspp5078id26n5nhidp1d4z9c";
  };

  buildInputs = [ dbus_glib polkit intltool libxslt docbook_xsl udev libusb1 ];

  buildNativeInputs = [ xz pkgconfig ];

  configureFlags = "--with-backend=linux --localstatedir=/var";

  preConfigure =
    ''
      substituteInPlace src/linux/up-backend.c \
        --replace /usr/bin/pm- ${pmutils}/bin/pm- \
        --replace /usr/sbin/pm- ${pmutils}/sbin/pm-
    '';

  installFlags = "localstatedir=$(TMPDIR)/var";

  meta = {
    homepage = http://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = stdenv.lib.platforms.linux;
  };
}
