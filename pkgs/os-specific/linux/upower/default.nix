{ stdenv, fetchurl, xz, pkgconfig, glib, dbus, dbus_glib, polkit
, intltool, libxslt, docbook_xsl, udev, libusb1, pmutils }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.9.12";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1c2b2f74vxx1y7vkwbrx5z4j5pdgvsw00l6cldvy7a4k7hrbprq6";
  };

  buildInputs =
    [ xz pkgconfig glib dbus dbus_glib polkit intltool
      libxslt docbook_xsl udev libusb1
    ];

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
  };
}
