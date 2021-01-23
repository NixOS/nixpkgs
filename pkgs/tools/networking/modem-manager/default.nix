{ lib, stdenv, fetchurl, glib, udev, libgudev, polkit, ppp, gettext, pkg-config
, libmbim, libqmi, systemd, vala, gobject-introspection, dbus }:

stdenv.mkDerivation rec {
  pname = "modem-manager";
  version = "1.14.8";

  package = "ModemManager";
  src = fetchurl {
    url = "https://www.freedesktop.org/software/${package}/${package}-${version}.tar.xz";
    sha256 = "15cjy7zzsxagx649vz0990avin47vpgdmm4ss2msggdla6x2c6py";
  };

  nativeBuildInputs = [ vala gobject-introspection gettext pkg-config ];

  buildInputs = [ glib udev libgudev polkit ppp libmbim libqmi systemd ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemd-suspend-resume"
    "--with-systemd-journal"
  ];

  preCheck = ''
    export G_TEST_DBUS_DAEMON="${dbus.daemon}/bin/dbus-daemon"
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = "https://www.freedesktop.org/wiki/Software/ModemManager/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
