{ stdenv, fetchurl, pkgconfig, openconnect, file, gawk,
  openvpn, vpnc, glib, dbus, iptables, gnutls, polkit,
  wpa_supplicant, readline6, pptp, ppp }:

stdenv.mkDerivation rec {
  name = "connman-${version}";
  version = "1.37";
  src = fetchurl {
    url = "mirror://kernel/linux/network/connman/${name}.tar.xz";
    sha256 = "05kfjiqhqfmbbwc4snnyvi5hc4zxanac62f6gcwaf5mvn0z9pqkc";
  };

  buildInputs = [ openconnect polkit
                  openvpn vpnc glib dbus iptables gnutls
                  wpa_supplicant readline6 pptp ppp ];

  nativeBuildInputs = [ pkgconfig file gawk ];

  preConfigure = ''
    export WPASUPPLICANT=${wpa_supplicant}/sbin/wpa_supplicant
    export PPPD=${ppp}/sbin/pppd
    export AWK=${gawk}/bin/gawk
    sed -i "s/\/usr\/bin\/file/file/g" ./configure
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
    "--with-pptp=${pptp}/sbin/pptp"
    "--enable-iwd"
  ];

  postInstall = ''
    cp ./client/connmanctl $out/sbin/connmanctl
  '';

  meta = with stdenv.lib; {
    description = "A daemon for managing internet connections";
    homepage = https://01.org/connman;
    maintainers = [ maintainers.matejc ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
