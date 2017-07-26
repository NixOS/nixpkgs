{ stdenv, fetchurl, intltool, pkgconfig, dbus_glib
, systemd, libgudev, libnl, libuuid, polkit, gnutls, ppp, dhcp, iptables
, libgcrypt, dnsmasq, bluez5, readline
, gobjectIntrospection, modemmanager, openresolv, libndp, newt, libsoup
, ethtool, iputils, gnused, coreutils, file, inetutils, kmod, jansson, libxslt
, python3Packages, docbook_xsl, fetchpatch, openconnect }:

stdenv.mkDerivation rec {
  name    = "network-manager-${version}";
  pname   = "NetworkManager";
  major   = "1.6";
  version = "${major}.2";
  # FIXME: this problem is fixed upstream (commit 6a77258f4ec2), remove when upgrading ^^^
  hardeningDisable = [ "format" ];

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${major}/${pname}-${version}.tar.xz";
    sha256 = "1y96k82rav8if334jl500zc024d210c4pgprh94yqyz3rmanyaxj";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    patchShebangs ./tools
  '';

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/uname ${coreutils}/bin/uname
    substituteInPlace configure --replace /usr/bin/file ${file}/bin/file
    substituteInPlace src/devices/nm-device.c \
       --replace /usr/bin/ping ${inetutils}/bin/ping \
       --replace /usr/bin/ping6 ${inetutils}/bin/ping
    substituteInPlace src/devices/nm-arping-manager.c \
       --replace '("arping", NULL, NULL);' '("arping", "${iputils}/bin/arping", NULL);'
    substituteInPlace data/84-nm-drivers.rules \
      --replace /bin/sh ${stdenv.shell}
    substituteInPlace data/85-nm-unmanaged.rules \
      --replace /bin/sh ${stdenv.shell} \
      --replace /usr/sbin/ethtool ${ethtool}/sbin/ethtool \
      --replace /bin/sed ${gnused}/bin/sed
    substituteInPlace data/NetworkManager.service.in \
      --replace /bin/kill ${coreutils}/bin/kill
    substituteInPlace clients/common/nm-vpn-helpers.c \
      --subst-var-by openconnect ${openconnect}
    substituteInPlace src/nm-core-utils.c \
      --subst-var-by modprobeBinPath ${kmod}/bin/modprobe
    # to enable link-local connections
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

  patches = [
    ./PppdPath.patch
    (fetchpatch {
      sha256 = "1n90j5rwg97xkrhlldyr92filc2dmycl9pr0svky9hlcn9csk2z6";
      name = "null-dereference.patch";
      url = "https://github.com/NetworkManager/NetworkManager/commit/4e8eddd100bbc8429806a70620c90b72cfd29cb1.patch";
    })
    ./openconnect_helper_path.patch
    ./modprobe.patch
  ];

  buildInputs = [ systemd libgudev libnl libuuid polkit ppp libndp
                  bluez5 dnsmasq gobjectIntrospection modemmanager readline newt libsoup jansson ];

  propagatedBuildInputs = [ dbus_glib gnutls libgcrypt python3Packages.pygobject3 ];

  nativeBuildInputs = [ intltool pkgconfig libxslt docbook_xsl ];

  preInstall = ''
    installFlagsArray=( "sysconfdir=$out/etc" "localstatedir=$out/var" "runstatedir=$out/var/run" )
  '';

  postInstall = ''
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
    homepage    = http://projects.gnome.org/NetworkManager/;
    description = "Network configuration and management tool";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom rickynils domenkozar obadz ];
    platforms   = platforms.linux;
  };
}
