{ stdenv, fetchurl, udev, libgudev, polkit, dbus_glib, ppp, intltool, pkgconfig
, libmbim, libqmi, systemd }:

stdenv.mkDerivation rec {
  name = "ModemManager-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/ModemManager/${name}.tar.xz";
    sha256 = "14v31j916h63z7af107rias1zbb2y94p3jg77zhzhrn1v6c46m74";
  };

  nativeBuildInputs = [ intltool pkgconfig ];

  buildInputs = [ udev libgudev polkit dbus_glib ppp libmbim libqmi systemd ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=$(out)/lib/udev"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-suspend-resume=systemd"
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
    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
