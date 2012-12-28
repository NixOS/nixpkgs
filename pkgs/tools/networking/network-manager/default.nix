{ stdenv, fetchurl, intltool, wirelesstools, pkgconfig, dbus_glib, xz
, udev, libnl, libuuid, polkit, gnutls, ppp, dhcp, dhcpcd, iptables
, libgcrypt, dnsmasq, avahi, bind, perl, substituteAll }:

stdenv.mkDerivation rec {
  name = "network-manager-${version}";
  version = "0.9.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/0.9/NetworkManager-${version}.tar.xz";
    sha256 = "eb4f124008b3d855a37205d03ef035b7218639cd7332bdae5567095977e93e0f";
  };

  preConfigure = ''
    substituteInPlace tools/glib-mkenums --replace /usr/bin/perl ${perl}/bin/perl
  '';

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  configureFlags = [
    "--with-distro=exherbo"
    "--with-dhclient=${dhcp}/sbin/dhclient"
    # Upstream prefers dhclient, so don't add dhcpcd to the closure
    #"--with-dhcpcd=${dhcpcd}/sbin/dhcpcd"
    "--with-dhcpcd=no"
    "--with-iptables=${iptables}/sbin/iptables"
    "--with-udev-dir=\${out}/lib/udev"
    "--without-resolvconf"
    "--sysconfdir=/etc" "--localstatedir=/var"
    "--with-dbus-sys-dir=\${out}/etc/dbus-1/system.d"
    "--with-crypto=gnutls" "--disable-more-warnings" ];

  buildInputs = [ wirelesstools udev libnl libuuid polkit ppp xz ];

  propagatedBuildInputs = [ dbus_glib gnutls libgcrypt ];

  nativeBuildInputs = [ intltool pkgconfig ];

  patches =
    [ ( substituteAll {
        src = ./nixos-purity.patch;
        inherit avahi dnsmasq ppp bind;
        glibc = stdenv.gcc.libc;
      })
    ];

  preInstall =
    ''
      installFlagsArray=( "sysconfdir=$out/etc" "localstatedir=$out/var" )
    '';

  postInstall =
    ''
      mkdir -p $out/lib/NetworkManager
    '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "Network configuration and management in an easy way. Desktop environment independent.";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms = platforms.linux;
  };
}
