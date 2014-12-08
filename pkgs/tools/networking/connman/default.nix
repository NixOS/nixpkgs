{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, openconnect, file,
  openvpn, vpnc, glib, dbus, iptables, gnutls, policykit, polkit,
  wpa_supplicant, readline6, pptp, ppp, tree }:

stdenv.mkDerivation rec {
  name = "connman-${version}";
  version = "1.26";
  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/connman/connman.git";
    rev = "refs/tags/${version}";
    sha256 = "0pj404iyq6x9x4i2dwqk1dx95yglx7pvkm8cvh13bf50dim92cv9";
  };

  buildInputs = [ autoconf automake libtool pkgconfig openconnect polkit
                  file openvpn vpnc glib dbus iptables gnutls policykit
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

  meta = {
    description = "Provides a daemon for managing internet connections";
    homepage = "https://connman.net/";
    maintainers = [ stdenv.lib.maintainers.matejc ];
    # tested only on linux, might work on others also
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
