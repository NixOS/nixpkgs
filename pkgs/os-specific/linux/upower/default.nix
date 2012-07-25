{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, polkit
, intltool, libxslt, docbook_xsl, udev, libusb1, pmutils }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.9.17";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0a1j2pg44r6ljj9jgzlw8i5fzabpm2b2jk058kxsr77ciz96i7yg";
  };

  buildInputs = [ dbus_glib polkit intltool libxslt docbook_xsl udev libusb1 ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags = "--with-backend=linux --localstatedir=/var";

  preConfigure =
    ''
      substituteInPlace src/linux/up-backend.c \
        --replace /usr/bin/pm- ${pmutils}/bin/pm- \
        --replace /usr/sbin/pm- ${pmutils}/sbin/pm-
    '';

  installFlags = "historydir=$(TMPDIR)/foo";

  meta = {
    homepage = http://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = stdenv.lib.platforms.linux;
  };
}
