{ lib
, nixosTests
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, autoreconfHook
, file
, glib
# always required runtime dependencies
, dbus
, libmnl
, gnutls
, readline
# configurable options
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
, enableHh2serialGps ? false
, enableL2tp ? false
, enableIospm ? false
, enableTist ? false
}:

assert lib.asserts.assertOneOf "firewallType" firewallType [ "iptables" "nftables" ];
assert lib.asserts.assertOneOf "dnsType" dnsType [ "internal" "systemd-resolved" ];

let inherit (lib) optionals; in

stdenv.mkDerivation rec {
  pname = "connman";
  version = "1.42";
  src = fetchurl {
    url = "mirror://kernel/linux/network/connman/${pname}-${version}.tar.xz";
    hash = "sha256-o+a65G/Age8una48qk92Sd6JLD3mIsICg6wMqBQjwqo=";
  };

  patches = [
    # simply the middle section of upstream commit a48864a2e5d2a725dfc6eef567108bc13b43857f
    # dist tarball is broken, hence this patch as a workaround
    ./create-libppp-compat.h.patch
  ] ++ optionals stdenv.hostPlatform.isMusl [
    # Fix Musl build by avoiding a Glibc-only API.
    (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/community/connman/libresolv.patch?id=e393ea84386878cbde3cccadd36a30396e357d1e";
      hash = "sha256-7Q1bp8rD/gGVYUqnIXqjr9vypR8jlC926p3KYWl9kLw=";
    })
  ];

  buildInputs = [
    glib
    dbus
    libmnl
    gnutls
    readline
  ] ++ optionals (enableOpenconnect) [ openconnect ]
    ++ optionals (firewallType == "iptables") [ iptables ]
    ++ optionals (firewallType == "nftables") [ libnftnl ]
    ++ optionals (enablePolkit) [ polkit ]
    ++ optionals (enablePptp) [ pptp ppp ]
  ;

  nativeBuildInputs = [
    pkg-config
    file
    autoreconfHook  # as long as we're patching configure.ac
  ];

  # fix invalid path to 'file'
  postPatch = ''
    sed -i "s/\/usr\/bin\/file/file/g" ./configure
  '';

  configureFlags = [
    # directories flags
    "--sysconfdir=/etc"
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
    # for building and running tests
    # "--enable-tests" # installs the tests, we don't want that
    "--enable-tools"
  ]
    ++ optionals (!enableLoopback) [ "--disable-loopback" ]
    ++ optionals (!enableEthernet) [ "--disable-ethernet" ]
    ++ optionals (!enableWireguard) [ "--disable-wireguard" ]
    ++ optionals (!enableGadget) [ "--disable-gadget" ]
    ++ optionals (!enableWifi) [ "--disable-wifi" ]
    # enable IWD support for wifi as it doesn't require any new dependencies
    # and it's easier for the NixOS module to use only one connman package when
    # IWD is requested
    ++ optionals (enableWifi) [ "--enable-iwd" ]
    ++ optionals (!enableBluetooth) [ "--disable-bluetooth" ]
    ++ optionals (!enableOfono) [ "--disable-ofono" ]
    ++ optionals (!enableDundee) [ "--disable-dundee" ]
    ++ optionals (!enablePacrunner) [ "--disable-pacrunner" ]
    ++ optionals (!enableNeard) [ "--disable-neard" ]
    ++ optionals (!enableWispr) [ "--disable-wispr" ]
    ++ optionals (!enableTools) [ "--disable-tools" ]
    ++ optionals (!enableStats) [ "--disable-stats" ]
    ++ optionals (!enableClient) [ "--disable-client" ]
    ++ optionals (!enableDatafiles) [ "--disable-datafiles" ]
    ++ optionals (enableOpenconnect) [
      "--enable-openconnect=builtin"
      "--with-openconnect=${openconnect}/sbin/openconnect"
    ]
    ++ optionals (enableOpenvpn) [
      "--enable-openvpn=builtin"
      "--with-openvpn=${openvpn}/sbin/openvpn"
    ]
    ++ optionals (enableVpnc) [
      "--enable-vpnc=builtin"
      "--with-vpnc=${vpnc}/sbin/vpnc"
    ]
    ++ optionals (enablePolkit) [
      "--enable-polkit"
    ]
    ++ optionals (enablePptp) [
      "--enable-pptp"
      "--with-pptp=${pptp}/sbin/pptp"
    ]
    ++ optionals (!enableWireguard) [
      "--disable-wireguard"
    ]
    ++ optionals (enableNetworkManager) [
      "--enable-nmcompat"
    ]
    ++ optionals (enableHh2serialGps) [
      "--enable-hh2serial-gps"
    ]
    ++ optionals (enableL2tp) [
      "--enable-l2tp"
    ]
    ++ optionals (enableIospm) [
      "--enable-iospm"
    ]
    ++ optionals (enableTist) [
      "--enable-tist"
    ]
  ;

  doCheck = true;

  passthru.tests.connman = nixosTests.connman;

  meta = with lib; {
    description = "A daemon for managing internet connections";
    homepage = "https://git.kernel.org/pub/scm/network/connman/connman.git/";
    maintainers = with maintainers; [ eclairevoyant ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
