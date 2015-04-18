{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, dbus_tools
, intltool, libxslt, docbook_xsl, udev, libusb1, pmutils
, useSystemd ? true, systemd, gobjectIntrospection
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.99.2";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0vwlh20jmaf01m38kfn8yx2869a3clmkzlycrj99rf4nvwx4bp79";
  };

  buildInputs =
    [ dbus_glib intltool libxslt docbook_xsl udev libusb1 gobjectIntrospection ]
    ++ stdenv.lib.optional useSystemd systemd;

  nativeBuildInputs = [ pkgconfig ];

  preConfigure =
    ''
      substituteInPlace src/linux/up-backend.c \
        --replace /usr/bin/pm- ${pmutils}/bin/pm- \
        --replace /usr/sbin/pm- ${pmutils}/sbin/pm-
      substituteInPlace src/notify-upower.sh \
        --replace /usr/bin/dbus-send ${dbus_tools}/bin/dbus-send
    '';

  configureFlags =
    [ "--with-backend=linux" "--localstatedir=/var"
      "--enable-deprecated" # needed for Xfce (Nov 2013)
    ]
    ++ stdenv.lib.optional useSystemd
    [ "--enable-systemd"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
      "--with-systemdutildir=$(out)/lib/systemd"
      "--with-udevrulesdir=$(out)/lib/udev/rules.d"
    ];

  NIX_CFLAGS_LINK = "-lgcc_s";

  installFlags = "historydir=$(TMPDIR)/foo";

  meta = {
    homepage = http://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = stdenv.lib.platforms.linux;
  };
}
