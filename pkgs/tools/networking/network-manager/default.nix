{ stdenv, fetchurl, intltool, wirelesstools, pkgconfig, dbus, dbus_glib
, udev, libnl1, libuuid, polkit, gnutls, ppp, dhcp, iptables, libtasn1
, libgcrypt }:
stdenv.mkDerivation rec {

  name = "network-manager-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/0.8/NetworkManager-${version}.tar.bz2";
    sha256 = "1yhr1zc9p2dakvg6m33jgkf09r6f6bzly7kqqjcpim4r66z6y4nw";
  };

  configureFlags = [ "--with-distro=gentoo" "--with-dhclient=${dhcp}/sbin"
    "--with-dhcpcd=${dhcp}/sbin" "--with-iptables=${iptables}/sbin/iptables"
    "--with-crypto=gnutls" "--disable-more-warnings"
    "--with-udev-dir=\${out}/lib/udev" ];

  buildInputs = [ intltool wirelesstools pkgconfig dbus dbus_glib udev libnl1 libuuid polkit gnutls ppp libtasn1 libgcrypt ];

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "Network configuration and management in an easy way. Desktop environment independent.";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
