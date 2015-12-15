{ stdenv, fetchurl, intltool, wirelesstools, pkgconfig, dbus_glib, xz
, udev, libgudev, libnl, libuuid, polkit, gnutls, ppp, dhcp, dhcpcd, iptables
, libgcrypt, dnsmasq, avahi, bind, perl, bluez5, substituteAll, readline
, gobjectIntrospection, modemmanager, openresolv, libndp, newt, libsoup
, ethtool, gnused }:

stdenv.mkDerivation rec {
  name = "network-manager-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/1.0/NetworkManager-${version}.tar.xz";
    sha256 = "38ea002403e3b884ffa9aae25aea431d2a8420f81f4919761c83fb92648254bd";
  };

  preConfigure = ''
    substituteInPlace tools/glib-mkenums --replace /usr/bin/perl ${perl}/bin/perl
    substituteInPlace src/ppp-manager/nm-ppp-manager.c --replace /sbin/modprobe /run/current-system/sw/sbin/modprobe
    substituteInPlace src/devices/nm-device.c --replace /sbin/modprobe /run/current-system/sw/sbin/modprobe
    substituteInPlace data/85-nm-unmanaged.rules \
      --replace /bin/sh ${stdenv.shell} \
      --replace /usr/sbin/ethtool ${ethtool}/sbin/ethtool \
      --replace /bin/sed ${gnused}/bin/sed
    configureFlags="$configureFlags --with-udev-dir=$out/lib/udev"
  '';

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  configureFlags = [
    "--with-distro=exherbo"
    "--with-dhclient=${dhcp}/bin/dhclient"
    "--with-dnsmasq=${dnsmasq}/bin/dnsmasq"
    # Upstream prefers dhclient, so don't add dhcpcd to the closure
    #"--with-dhcpcd=${dhcpcd}/sbin/dhcpcd"
    "--with-dhcpcd=no"
    "--with-pppd=${ppp}/bin/pppd"
    "--with-iptables=${iptables}/bin/iptables"
    #"--with-udev-dir=$(out)/lib/udev"
    "--with-resolvconf=${openresolv}/sbin/resolvconf"
    "--sysconfdir=/etc" "--localstatedir=/var"
    "--with-dbus-sys-dir=\${out}/etc/dbus-1/system.d"
    "--with-crypto=gnutls" "--disable-more-warnings"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-kernel-firmware-dir=/run/current-system/firmware"
    "--with-session-tracking=systemd"
    "--with-modem-manager-1"
    "--with-nmtui"
    "--with-libsoup=yes"
  ];

  buildInputs = [ wirelesstools udev libgudev libnl libuuid polkit ppp libndp
                  xz bluez5 dnsmasq gobjectIntrospection modemmanager readline newt libsoup ];

  propagatedBuildInputs = [ dbus_glib gnutls libgcrypt ];

  nativeBuildInputs = [ intltool pkgconfig ];

  patches = [ ./nm-platform.patch ];

  preInstall =
    ''
      installFlagsArray=( "sysconfdir=$out/etc" "localstatedir=$out/var" )
    '';

  postInstall =
    ''
      mkdir -p $out/lib/NetworkManager

      # FIXME: Workaround until NixOS' dbus+systemd supports at_console policy
      substituteInPlace $out/etc/dbus-1/system.d/org.freedesktop.NetworkManager.conf --replace 'at_console="true"' 'group="networkmanager"'

      # rename to network-manager to be in style
      mv $out/etc/systemd/system/NetworkManager.service $out/etc/systemd/system/network-manager.service 

      # systemd in NixOS doesn't use `systemctl enable`, so we need to establish
      # aliases ourselves.
      ln -s $out/etc/systemd/system/NetworkManager-dispatcher.service $out/etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
      ln -s $out/etc/systemd/system/network-manager.service $out/etc/systemd/system/dbus-org.freedesktop.NetworkManager.service
    '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "Network configuration and management tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom urkud rickynils iElectric ];
    platforms = platforms.linux;
  };
}
