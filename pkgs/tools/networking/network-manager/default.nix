{ stdenv, fetchurl, substituteAll, intltool, pkgconfig, dbus-glib, gnome3
, systemd, libuuid, polkit, gnutls, ppp, dhcp, iptables
, libgcrypt, dnsmasq, bluez5, readline
, gobjectIntrospection, modemmanager, openresolv, libndp, newt, libsoup
, ethtool, gnused, coreutils, file, inetutils, kmod, jansson, libxslt
, python3Packages, docbook_xsl, openconnect, curl, autoreconfHook }:

let
  pname = "NetworkManager";
in stdenv.mkDerivation rec {
  name = "network-manager-${version}";
  version = "1.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09hsh34m8hg4m402pw5n11f29vsfjw6lm3p5m56yxwq57bwnzq3b";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    patchShebangs ./tools
  '';

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/uname ${coreutils}/bin/uname
    substituteInPlace configure --replace /usr/bin/file ${file}/bin/file
    substituteInPlace data/84-nm-drivers.rules \
      --replace /bin/sh ${stdenv.shell}
    substituteInPlace data/85-nm-unmanaged.rules \
      --replace /bin/sh ${stdenv.shell} \
      --replace /usr/sbin/ethtool ${ethtool}/sbin/ethtool \
      --replace /bin/sed ${gnused}/bin/sed
    substituteInPlace data/NetworkManager.service.in \
      --replace /bin/kill ${coreutils}/bin/kill
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
    "--with-libnm-glib" # legacy library, TODO: remove
    "--disable-tests"
  ];

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=796751
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=372953;
      sha256 = "1crjplyiiipkhjjlifrv6hhvxinlcxd6irp9ijbc7jij31g44i0a";
    })
    (fetchurl {
      url = https://gitlab.freedesktop.org/NetworkManager/NetworkManager/commit/0a3755c1799d3a4dc1875d4c59c7c568a64c8456.patch;
      sha256 = "af1717f7c6fdd6dadb4082dd847f4bbc42cf1574833299f3e47024e785533f2e";
    })
    (substituteAll {
      src = ./fix-paths.patch;
      inherit inetutils kmod openconnect;
    })

  ];

  buildInputs = [
    systemd libuuid polkit ppp libndp curl
    bluez5 dnsmasq gobjectIntrospection modemmanager readline newt libsoup jansson
  ];

  propagatedBuildInputs = [ dbus-glib gnutls libgcrypt python3Packages.pygobject3 ];

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig libxslt docbook_xsl ];

  doCheck = false; # requires /sys, the net

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
    homepage = https://wiki.gnome.org/Projects/NetworkManager;
    description = "Network configuration and management tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom rickynils domenkozar obadz ];
    platforms = platforms.linux;
  };
}
