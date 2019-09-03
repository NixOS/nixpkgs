{ stdenv
, fetchurl
, pkgconfig
, dbus-glib
, intltool
, libxslt
, docbook_xsl
, udev
, libgudev
, libusb1
, gobject-introspection
, useSystemd ? true, systemd
}:

stdenv.mkDerivation rec {
  pname = "upower";
  version = "0.99.11";

  src = fetchurl {
    url = https://gitlab.freedesktop.org/upower/upower/uploads/93cfe7c8d66ed486001c4f3f55399b7a/upower-0.99.11.tar.xz;
    sha256 = "1vxxvmz2cxb1qy6ibszaz5bskqdy9nd9fxspj9fv3gfmrjzzzdb4";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    dbus-glib
    intltool
    libxslt
    docbook_xsl
    udev
    libgudev
    libusb1
    gobject-introspection
  ]
  ++ stdenv.lib.optional useSystemd systemd
  ;

  configureFlags = [
    "--with-backend=linux"
    "--localstatedir=/var"
  ]
  ++ stdenv.lib.optional useSystemd [
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemdutildir=${placeholder "out"}/lib/systemd"
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
  ]
  ;

  doCheck = false; # fails with "env: './linux/integration-test': No such file or directory"

  installFlags = [
    "historydir=$(TMPDIR)/foo"
  ];

  meta = with stdenv.lib; {
    homepage = https://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
