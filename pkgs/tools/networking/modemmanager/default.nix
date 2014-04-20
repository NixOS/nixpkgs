{ stdenv, fetchurl, udev, polkit, dbus_glib, ppp, intltool, pkgconfig, libmbim, libqmi }:

stdenv.mkDerivation rec {
  name = "ModemManager-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/ModemManager/${name}.tar.xz";
    sha256 = "1g08ciyhys9bi5m45z30kln17zni4r07i5byjaglmwq6np1xincb";
  };

  nativeBuildInputs = [ intltool pkgconfig ];

  buildInputs = [ udev polkit dbus_glib ppp libmbim libqmi ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=$(out)/lib/udev"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  postInstall = ''
    # systemd in NixOS doesn't use `systemctl enable`, so we need to establish
    # aliases ourselves.
    ln -s $out/etc/systemd/system/ModemManager.service \
      $out/etc/systemd/system/dbus-org.freedesktop.ModemManager1.service
  '';

  meta = {
    description = "WWAN modem manager, part of NetworkManager";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
