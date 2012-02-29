{ stdenv, fetchurl, intltool, wirelesstools, pkgconfig, dbus_glib, xz
, udev, libnl1, libuuid, polkit, gnutls, ppp, dhcp, dhcpcd, iptables
, libgcrypt, dnsmasq, avahi }:

stdenv.mkDerivation rec {
  name = "network-manager-${version}";
  version = "0.9.2.0";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/0.9/NetworkManager-${version}.tar.xz";
    sha256 = "1pvd49ji7mh8ww2rfbvq6hmmjms5mb7w10fr7ihgzqbg589zjyj3";
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

  buildInputs = [ wirelesstools udev libnl1 libuuid polkit ppp xz ];

  propagatedBuildInputs = [ dbus_glib gnutls libgcrypt ];

  buildNativeInputs = [ intltool pkgconfig ];

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
