{ stdenv, fetchurl, intltool, pkgconfig, dbus-glib
, udev, libnl, libuuid, gnutls, dhcp
, libgcrypt, perl, libgudev, avahi, ppp, kmod }:

stdenv.mkDerivation rec {
  name = "network-manager-${version}";
  version = "0.9.8.10";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/0.9/NetworkManager-${version}.tar.xz";
    sha256 = "0wn9qh8r56r8l19dqr68pdl1rv3zg1dv47rfy6fqa91q7li2fk86";
  };

  preConfigure = ''
    substituteInPlace tools/glib-mkenums --replace /usr/bin/perl ${perl}/bin/perl
    substituteInPlace src/nm-device.c \
      --replace @avahi@ ${avahi} \
      --replace @kmod@ ${kmod}
    substituteInPlace src/ppp-manager/nm-ppp-manager.c \
      --replace @ppp@ ${ppp} \
      --replace @kmod@ ${kmod}
  '';

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  configureFlags = [
    "--with-distro=exherbo"
    "--with-dhclient=${dhcp}/sbin/dhclient"
    "--with-dhcpcd=no"
    "--with-iptables=no"
    "--with-udev-dir=\${out}/lib/udev"
    "--with-resolvconf=no"
    "--sysconfdir=/etc" "--localstatedir=/var"
    "--with-dbus-sys-dir=\${out}/etc/dbus-1/system.d"
    "--with-crypto=gnutls" "--disable-more-warnings"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-kernel-firmware-dir=/run/current-system/firmware"
    "--disable-ppp"
  ];

  buildInputs = [ udev libnl libuuid gnutls libgcrypt libgudev ];

  propagatedBuildInputs = [ dbus-glib ];

  nativeBuildInputs = [ intltool pkgconfig ];

  patches =
    [ ./libnl-3.2.25.patch
      ./nixos-purity.patch
    ];

  preInstall =
    ''
      installFlagsArray=( "sysconfdir=$out/etc" "localstatedir=$out/var" )
    '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "Network configuration and management tool";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
