{ stdenv, fetchurl, pkgconfig, dbus-glib
, intltool, libxslt, docbook_xsl, udev, libgudev, libusb1
, useSystemd ? true, systemd, gobject-introspection
}:

stdenv.mkDerivation rec {
  name = "upower-0.99.9";

  src = fetchurl {
    url = https://gitlab.freedesktop.org/upower/upower/uploads/2282c7c0e53fb31816b824c9d1f547e8/upower-0.99.9.tar.xz;
    sha256 = "046ix7j7hmb7ycv8v54668kjsrgjhzwxn299c1d87vdnkd38kfh1";
  };

  buildInputs =
    [ dbus-glib intltool libxslt docbook_xsl udev libgudev libusb1 gobject-introspection ]
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

  doCheck = false; # fails with "env: './linux/integration-test': No such file or directory"

  installFlags = "historydir=$(TMPDIR)/foo";

  meta = {
    homepage = https://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
