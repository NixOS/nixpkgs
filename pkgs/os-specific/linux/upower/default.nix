{ stdenv, fetchurl, pkgconfig, dbus-glib
, intltool, libxslt, docbook_xsl, udev, libgudev, libusb1
, useSystemd ? true, systemd, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "upower-0.99.8";

  src = fetchurl {
    url = https://gitlab.freedesktop.org/upower/upower/uploads/9125ab7ee96fdc4ecc68cfefb50c1cab/upower-0.99.8.tar.xz;
    sha256 = "00lzr0vyxz5lvmgya48gdb2cdgmfdim4b34jlfdyqakk1i9sl8xv";
  };

  buildInputs =
    [ dbus-glib intltool libxslt docbook_xsl udev libgudev libusb1 gobjectIntrospection ]
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
