{ stdenv
, fetchurl
, pkgconfig
, file
, glib
# always required runtime dependencies
, dbus
, libmnl
, gnutls
, readline
# Choices one has to decide
, firewallType ? "iptables" # or "nftables"
, iptables ? null
, libnftnl ? null # for nftables
, dnsType ? "internal" # or "systemd-resolved"
# optional features which are turned *on* by default
, enableOpenconnect ? true
, openconnect ? null
, enableOpenvpn ? true
, openvpn ? null
, enableVpnc ? true
, vpnc ? true
, enablePolkit ? true
, polkit ? null
, enablePptp ? true
, pptp ? null
, ppp ? null
, enableLoopback ? true
, enableEthernet ? true
, enableWireguard ? true
, enableGadget ? true
, enableWifi ? true
, enableBluetooth ? true
, enableOfono ? true
, enableDundee ? true
, enablePacrunner ? true
, enableNeard ? true
, enableWispr ? true
, enableTools ? true
, enableStats ? true
, enableClient ? true
, enableDatafiles ? true
# optional features which are turned *off* by default
, enableNetworkManager ? false
, networkmanager ? null
, enableHh2serialGps ? false
, enableL2tp ? false
, enableIospm ? false
, enableTist ? false
}:

assert stdenv.lib.asserts.assertOneOf "firewallType" firewallType [ "iptables" "nftables" ];
assert stdenv.lib.asserts.assertOneOf "dnsType" dnsType [ "internal" "systemd-resolved" ];

stdenv.mkDerivation rec {
  pname = "connman";
  version = "1.38";
  src = fetchurl {
    url = "mirror://kernel/linux/network/connman/${pname}-${version}.tar.xz";
    sha256 = "0awkqigvhwwxiapw0x6yd4whl465ka8a4al0v2pcqy9ggjlsqc6b";
  };

  buildInputs = [
    glib
    dbus
    libmnl
    gnutls
    readline
  ];

  nativeBuildInputs = [
    pkgconfig
    file
  ]
    ++ stdenv.lib.optionals (enableOpenvpn) [ openvpn ]
    ++ stdenv.lib.optionals (enableOpenconnect) [ openconnect ]
    ++ stdenv.lib.optionals (enableVpnc) [ vpnc ]
    ++ stdenv.lib.optionals (enablePolkit) [ polkit ]
    ++ stdenv.lib.optionals (enablePptp) [ pptp ppp ]
    ++ stdenv.lib.optionals (firewallType == "iptables") [ iptables ]
    ++ stdenv.lib.optionals (firewallType == "nftables") [ libnftnl ]
  ;

  # Fix file program not found
  preConfigure = ''
    sed -i "s/\/usr\/bin\/file/file/g" ./configure
  '';

  configureFlags = [
    # directories flags
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-dbusdatadir=${placeholder "out"}/share"
    "--with-tmpfilesdir=${placeholder "out"}/lib/tmpfiles.d"
    "--with-systemdunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-dns-backend=${dnsType}"
    "--with-firewall=${firewallType}"
    # production build flags
    "--disable-maintainer-mode"
    "--enable-session-policy-local=builtin"
    # This is for building and running tests (probably enabled by default),
    # --enable-tests installs the tests as well
    "--enable-tools"
  ]
    ++ stdenv.lib.optionals (!enableLoopback) [ "--disable-loopback" ]
    ++ stdenv.lib.optionals (!enableEthernet) [ "--disable-ethernet" ]
    ++ stdenv.lib.optionals (!enableWireguard) [ "--disable-wireguard" ]
    ++ stdenv.lib.optionals (!enableGadget) [ "--disable-gadget" ]
    ++ stdenv.lib.optionals (!enableWifi) [ "--disable-wifi" ]
    # We (almost) always turn on IWD support as it doesn't require any new dependencies
    # and it's easier for the NixOS module to use only 1 connmand package when
    # IWD is requested
    ++ stdenv.lib.optionals (enableWifi) [ "--enable-iwd" ]
    ++ stdenv.lib.optionals (!enableBluetooth) [ "--disable-bluetooth" ]
    ++ stdenv.lib.optionals (!enableOfono) [ "--disable-ofono" ]
    ++ stdenv.lib.optionals (!enableDundee) [ "--disable-dundee" ]
    ++ stdenv.lib.optionals (!enablePacrunner) [ "--disable-pacrunner" ]
    ++ stdenv.lib.optionals (!enableNeard) [ "--disable-neard" ]
    ++ stdenv.lib.optionals (!enableWispr) [ "--disable-wispr" ]
    ++ stdenv.lib.optionals (!enableTools) [ "--disable-tools" ]
    ++ stdenv.lib.optionals (!enableStats) [ "--disable-stats" ]
    ++ stdenv.lib.optionals (!enableClient) [ "--disable-client" ]
    ++ stdenv.lib.optionals (!enableDatafiles) [ "--disable-datafiles" ]
    ++ stdenv.lib.optionals (enableOpenconnect) [
      "--enable-openconnect=builtin"
      "--with-openconnect=${openconnect}/sbin/openconnect"
    ]
    ++ stdenv.lib.optionals (enableOpenvpn) [
      "--enable-openvpn=builtin"
      "--with-openvpn=${openvpn}/sbin/openvpn"
    ]
    ++ stdenv.lib.optionals (enableVpnc) [
      "--enable-vpnc=builtin"
      "--with-vpnc=${vpnc}/sbin/vpnc"
    ]
    ++ stdenv.lib.optionals (enablePolkit) [
      "--enable-polkit"
    ]
    ++ stdenv.lib.optionals (enablePptp) [
      "--enable-pptp"
      "--with-pptp=${pptp}/sbin/pptp"
    ]
    ++ stdenv.lib.optionals (!enableWireguard) [
      "--disable-wireguard"
    ]
    ++ stdenv.lib.optionals (enableNetworkManager) [
      "--enable-nmcompat"
    ]
    ++ stdenv.lib.optionals (enableHh2serialGps) [
      "--enable-hh2serial-gps"
    ]
    ++ stdenv.lib.optionals (enableL2tp) [
      "--enable-l2tp"
    ]
    ++ stdenv.lib.optionals (enableIospm) [
      "--enable-iospm"
    ]
    ++ stdenv.lib.optionals (enableTist) [
      "--enable-tist"
    ]
  ;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A daemon for managing internet connections";
    homepage = "https://01.org/connman";
    maintainers = [ maintainers.matejc ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
