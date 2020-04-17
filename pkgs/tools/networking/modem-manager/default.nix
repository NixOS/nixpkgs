{ stdenv, fetchurl, glib, udev, libgudev, polkit, ppp, gettext, pkgconfig
, libmbim, libqmi, systemd, vala, gobject-introspection, dbus }:

stdenv.mkDerivation rec {
  pname = "modem-manager";
  version = "1.12.6";

  package = "ModemManager";
  src = fetchurl {
    url = "https://www.freedesktop.org/software/${package}/${package}-${version}.tar.xz";
    sha256 = "0k32rjh06p3q9yq054gxya6c7n39bilhi4s23p2hb02iwlz3bcrf";
  };

  nativeBuildInputs = [ vala gobject-introspection gettext pkgconfig ];

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

  doCheck = true;

  meta = with stdenv.lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = "https://www.freedesktop.org/wiki/Software/ModemManager/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
