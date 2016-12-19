{ stdenv, fetchurl, pkgconfig, glib, dbus_glib
, intltool, libxslt, docbook_xsl, udev, libgudev, libusb1
, useSystemd ? true, systemd, gobjectIntrospection
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.99.4";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1c1ph1j1fnrf3vipxb7ncmdfc36dpvcvpsv8n8lmal7grjk2b8ww";
  };

  buildInputs =
    [ dbus_glib intltool libxslt docbook_xsl udev libgudev libusb1 gobjectIntrospection ]
    ++ stdenv.lib.optional useSystemd systemd;

  nativeBuildInputs = [ pkgconfig ];

  configureFlags =
    [ "--with-backend=linux" "--localstatedir=/var"
    ]
    ++ stdenv.lib.optional useSystemd
    [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
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
