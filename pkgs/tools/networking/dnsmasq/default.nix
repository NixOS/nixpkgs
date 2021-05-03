{ stdenv, fetchurl, pkgconfig, dbus, nettle, fetchpatch
, libidn, libnetfilter_conntrack }:

with stdenv.lib;
let
  copts = concatStringsSep " " ([
    "-DHAVE_IDN"
    "-DHAVE_DNSSEC"
  ] ++ optionals stdenv.isLinux [
    "-DHAVE_DBUS"
    "-DHAVE_CONNTRACK"
  ]);
in
stdenv.mkDerivation rec {
  pname = "dnsmasq";
  version = "2.85";

  src = fetchurl {
    url = "https://www.thekelleys.org.uk/dnsmasq/${pname}-${version}.tar.xz";
    sha256 = "sha256-rZjTgD32h+W5OAgPPSXGKP5ByHh1LQP7xhmXh/7jEvo=";
  };

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
    sed '1i#include <linux/sockios.h>' -i src/dhcp.c
  '';

  preBuild = ''
    makeFlagsArray=("COPTS=${copts}")
  '';

  makeFlags = [
    "DESTDIR="
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/man"
    "LOCALEDIR=$(out)/share/locale"
  ];

  hardeningEnable = [ "pie" ];

  postBuild = optionalString stdenv.isLinux ''
    make -C contrib/lease-tools
  '';

  # XXX: Does the systemd service definition really belong here when our NixOS
  # module can create it in Nix-land?
  postInstall = ''
    install -Dm644 trust-anchors.conf $out/share/dnsmasq/trust-anchors.conf
  '' + optionalString stdenv.isDarwin ''
    install -Dm644 contrib/MacOSX-launchd/uk.org.thekelleys.dnsmasq.plist \
      $out/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist
    substituteInPlace $out/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist \
      --replace "/usr/local/sbin" "$out/bin"
  '' + optionalString stdenv.isLinux ''
    install -Dm644 dbus/dnsmasq.conf $out/share/dbus-1/system.d/dnsmasq.conf
    install -Dm755 contrib/lease-tools/dhcp_lease_time $out/bin/dhcp_lease_time
    install -Dm755 contrib/lease-tools/dhcp_release $out/bin/dhcp_release
    install -Dm755 contrib/lease-tools/dhcp_release6 $out/bin/dhcp_release6

    mkdir -p $out/share/dbus-1/system-services
    cat <<END > $out/share/dbus-1/system-services/uk.org.thekelleys.dnsmasq.service
    [D-BUS Service]
    Name=uk.org.thekelleys.dnsmasq
    Exec=$out/bin/dnsmasq -k -1
    User=root
    SystemdService=dnsmasq.service
    END
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ nettle libidn ]
    ++ optionals stdenv.isLinux [ dbus libnetfilter_conntrack ];

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = "https://www.thekelleys.org.uk/dnsmasq/doc.html";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ eelco fpletz globin ];
  };
}
