{ lib
, stdenv
, fetchurl
, pkg-config
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
  version = "0.99.13";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/upower/upower/uploads/177df5b9f9b76f25a2ad9da41aa0c1fa/upower-0.99.13.tar.xz";
    sha256 = "sha256-XK1w+RVAzH3BIcsX4K1kXl5mPIaC9gp75C7jjNeyPXo=";
  };

  nativeBuildInputs = [
    docbook_xsl
    gettext
    gobject-introspection
    libxslt
    pkg-config
  ];

  buildInputs = [
    libgudev
    libusb1
    udev
    systemd
  ]
  ++ lib.optional useIMobileDevice libimobiledevice
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

  meta = with lib; {
    homepage = "https://upower.freedesktop.org/";
    description = "A D-Bus service for power management";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
