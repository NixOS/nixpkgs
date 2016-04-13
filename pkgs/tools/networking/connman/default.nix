{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, openconnect, file,
  openvpn, vpnc, glib, dbus, iptables, gnutls, polkit,
  wpa_supplicant, readline6, pptp, ppp, tree }:

stdenv.mkDerivation rec {
  name = "connman-${version}";
  version = "1.31";
  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/connman/connman.git";
    rev = "refs/tags/${version}";
    sha256 = "90dab6b11841cb4b6400711d234b59fb4fad4e8778bed6e7ad3ac7ac135d6893";
  };

  buildInputs = [ autoconf automake libtool pkgconfig openconnect polkit
                  file openvpn vpnc glib dbus iptables gnutls
                  wpa_supplicant readline6 pptp ppp tree ];

  preConfigure = ''
    export WPASUPPLICANT=${wpa_supplicant}/sbin/wpa_supplicant
    ./bootstrap
    sed -i "s/\/usr\/bin\/file/file/g" ./configure
    substituteInPlace configure --replace /usr/sbin/pptp ${pptp}/sbin/pptp
    substituteInPlace configure --replace /usr/sbin/pppd ${ppp}/sbin/pppd
  '';

  configureFlags = [
    "--sysconfdir=\${out}/etc"
    "--localstatedir=/var"
    "--with-dbusconfdir=\${out}/etc"
    "--with-dbusdatadir=\${out}/usr/share"
    "--disable-maintainer-mode"
    "--enable-openconnect=builtin"
    "--with-openconnect=${openconnect}/sbin/openconnect"
    "--enable-openvpn=builtin"
    "--with-openvpn=${openvpn}/sbin/openvpn"
    "--enable-vpnc=builtin"
    "--with-vpnc=${vpnc}/sbin/vpnc"
    "--enable-session-policy-local=builtin"
    "--enable-client"
    "--enable-bluetooth"
    "--enable-wifi"
    "--enable-polkit"
    "--enable-tools"
    "--enable-datafiles"
    "--enable-pptp"
  ];

  postInstall = ''
    cp ./client/connmanctl $out/sbin/connmanctl
  '';

  meta = with stdenv.lib; {
    description = "Provides a daemon for managing internet connections";
    homepage = "https://connman.net/";
    maintainers = [ maintainers.matejc ];
    # tested only on linux, might work on others also
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
