{ stdenv, fetchurl, intltool, wirelesstools, pkgconfig, dbus, dbus_glib
, udev, libnl1, libuuid, polkit, gnutls, ppp, dhcp, dhcpcd, iptables, libtasn1
, libgcrypt, dnsmasq, avahi }:

stdenv.mkDerivation rec {
  name = "network-manager-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/0.9/NetworkManager-${version}.tar.bz2";
    sha256 = "0kvi767c224zlja65r8gixmhj57292k0gsxa0217lw5i99l2incq";
  };

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

  buildInputs = [ intltool wirelesstools pkgconfig dbus dbus_glib udev libnl1
    libuuid polkit gnutls ppp libtasn1 libgcrypt ];

  patches = [ ./nixos-purity.patch ];

  preInstall =
    ''
      installFlagsArray=( "sysconfdir=$out/etc" "localstatedir=$out/var" )
    '';

  inherit avahi dnsmasq ppp;
  glibc = stdenv.gcc.libc;

  # Substitute full paths, check if there any not substituted path
  postPatch =
    ''
      for i in src/backends/NetworkManagerExherbo.c src/dns-manager/nm-dns-dnsmasq.c \
        src/dnsmasq-manager/nm-dnsmasq-manager.c src/nm-device.c src/ppp-manager/nm-ppp-manager.c; do
        substituteAll "$i" "$i"
      done
      find . -name \*.c | xargs grep '@[a-zA-Z]*@' && exit 1 || true
    '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "Network configuration and management in an easy way. Desktop environment independent.";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
