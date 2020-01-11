{ stdenv
, fetchurl
, pkgconfig
, libxslt
, docbook_xsl
, udev
, libgudev
, libusb1
, glib
, gobject-introspection
, gettext
, systemd
, useIMobileDevice ? true
, libimobiledevice
}:

stdenv.mkDerivation {
  pname = "upower";
  version = "0.99.11";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = https://gitlab.freedesktop.org/upower/upower/uploads/93cfe7c8d66ed486001c4f3f55399b7a/upower-0.99.11.tar.xz;
    sha256 = "1vxxvmz2cxb1qy6ibszaz5bskqdy9nd9fxspj9fv3gfmrjzzzdb4";
  };

  nativeBuildInputs = [
    docbook_xsl
    gettext
    gobject-introspection
    libxslt
    pkgconfig
  ];

  buildInputs = [
    libgudev
    libusb1
    udev
    systemd
  ]
  ++ stdenv.lib.optional useIMobileDevice libimobiledevice
  ;

  propagatedBuildInputs = [
    glib
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-backend=linux"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemdutildir=${placeholder "out"}/lib/systemd"
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--sysconfdir=/etc"
  ];

  doCheck = false; # fails with "env: './linux/integration-test': No such file or directory"

  installFlags = [
    "historydir=$(TMPDIR)/foo"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  meta = with stdenv.lib; {
    homepage = https://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
