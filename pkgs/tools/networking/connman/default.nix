{ stdenv
, fetchurl
, pkgconfig
, openconnect
, file
  openvpn
, vpnc
, glib
, dbus
, iptables
, gnutls
, polkit,
, readline6
, pptp
, ppp
}:

stdenv.mkDerivation rec {
  pname = "connman";
  version = "1.38";
  src = fetchurl {
    url = "mirror://kernel/linux/network/connman/${pname}-${version}.tar.xz";
    sha256 = "0awkqigvhwwxiapw0x6yd4whl465ka8a4al0v2pcqy9ggjlsqc6b";
  };

  buildInputs = [
    openconnect
    polkit
    openvpn
    vpnc
    glib
    dbus
    iptables
    gnutls
    readline6
    pptp
    ppp
  ];

  nativeBuildInputs = [
    pkgconfig
    file
  ];

  preConfigure = ''
    sed -i "s/\/usr\/bin\/file/file/g" ./configure
  '';

  configureFlags = [
    "--sysconfdir=\${out}/etc"
    "--localstatedir=/var"
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-dbusdatadir=${placeholder "out"}/share"
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
    "--with-pptp=${pptp}/sbin/pptp"
    "--enable-iwd"
  ];

  meta = with stdenv.lib; {
    description = "A daemon for managing internet connections";
    homepage = https://01.org/connman;
    maintainers = [ maintainers.matejc ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
