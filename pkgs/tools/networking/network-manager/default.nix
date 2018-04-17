{ stdenv, fetchurl, intltool, pkgconfig, dbus-glib, gnome3
, systemd, libgudev, libnl, libuuid, polkit, gnutls, ppp, dhcp, iptables
, libgcrypt, dnsmasq, bluez5, readline
, gobjectIntrospection, modemmanager, openresolv, libndp, newt, libsoup
, ethtool, iputils, gnused, coreutils, file, inetutils, kmod, jansson, libxslt
, python3Packages, docbook_xsl, fetchpatch, openconnect, curl, autoreconfHook }:

let
  pname   = "NetworkManager";
  version = "1.10.6";
in stdenv.mkDerivation rec {
  name    = "network-manager-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xmc3x41dbcaxjm85wfv405xq1a1n3xw8m8zg645ywm3avlb3w3a";
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

    # Fixes: error: po/Makefile.in.in was not created by intltoolize.
    intltoolize --automake --copy --force
  '';

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  configureFlags = [
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
    "--disable-gtk-doc"
  ];

  patches = [
    ./PppdPath.patch
    ./openconnect_helper_path.patch
    ./modprobe.patch
  ];

  buildInputs = [ systemd libgudev libnl libuuid polkit ppp libndp curl
                  bluez5 dnsmasq gobjectIntrospection modemmanager readline newt libsoup jansson ];

  propagatedBuildInputs = [ dbus-glib gnutls libgcrypt python3Packages.pygobject3 ];

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig libxslt docbook_xsl ];

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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager";
    };
  };

  meta = with stdenv.lib; {
    homepage    = https://wiki.gnome.org/Projects/NetworkManager;
    description = "Network configuration and management tool";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom rickynils domenkozar obadz ];
    platforms   = platforms.linux;
  };
}
