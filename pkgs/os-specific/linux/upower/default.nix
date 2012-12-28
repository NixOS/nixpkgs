{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, dbus_tools, polkit
, intltool, libxslt, docbook_xsl, udev, libusb1, pmutils
, useSystemd ? false, systemd ? null
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.9.18";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "13q6cw2d45qp077g3bjng4yhrvm6g1y9347dkf53kscm5xfm18d1";
  };

  buildInputs =
    [ dbus_glib polkit intltool libxslt docbook_xsl udev libusb1 ]
    ++ stdenv.lib.optional useSystemd systemd;

  nativeBuildInputs = [ pkgconfig ];

  configureFlags =
    [ "--with-backend=linux" "--localstatedir=/var" ]
    ++ stdenv.lib.optional useSystemd
    [ "--enable-systemd"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
      "--with-systemdutildir=$(out)/lib/systemd/system-sleep"
    ];

  preConfigure =
    ''
      substituteInPlace src/linux/up-backend.c \
        --replace /usr/bin/pm- ${pmutils}/bin/pm- \
        --replace /usr/sbin/pm- ${pmutils}/sbin/pm-
      substituteInPlace src/notify-upower.sh \
        --replace /usr/bin/dbus-send ${dbus_tools}/bin/dbus-send
    '';

  installFlags = "historydir=$(TMPDIR)/foo";

  meta = {
    homepage = http://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = stdenv.lib.platforms.linux;
  };
}
