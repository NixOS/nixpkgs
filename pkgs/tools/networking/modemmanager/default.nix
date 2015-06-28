{ stdenv, fetchurl, udev, polkit, dbus_glib, ppp, intltool, pkgconfig, libmbim, libqmi }:

stdenv.mkDerivation rec {
  name = "ModemManager-${version}";
  version = "1.4.6";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/ModemManager/${name}.tar.xz";
    sha256 = "1kd5nn5rm88c8rgmzwy2fsf3cr7fai7r85mi61kcby0hcgsapv8c";
  };

  nativeBuildInputs = [ intltool pkgconfig ];

  buildInputs = [ udev polkit dbus_glib ppp libmbim libqmi ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=$(out)/lib/udev"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [ "DESTDIR=\${out}" ];

  preInstall = ''
    mkdir -p $out/etc/systemd/system
  '';

  postInstall = ''
    mv $out/$out/etc/systemd/system/ModemManager.service $out/etc/systemd/system
    rm -rf $out/$out/etc
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done

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
