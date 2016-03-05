{ stdenv, fetchurl, pkgconfig, dbus_libs, nettle, libidn, libnetfilter_conntrack }:

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
  name = "dnsmasq-2.75";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.xz";
    sha256 = "1wa1d4if9q6k3hklv8xi06a59k3aqb7pik8rhi2l53i99hflw334";
  };

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
    make -C contrib/wrt
  '';

  # XXX: Does the systemd service definition really belong here when our NixOS
  # module can create it in Nix-land?
  postInstall = ''
    install -Dm644 trust-anchors.conf $out/share/dnsmasq/trust-anchors.conf
  '' + optionalString stdenv.isLinux ''
    install -Dm644 dbus/dnsmasq.conf $out/etc/dbus-1/system.d/dnsmasq.conf
    install -Dm755 contrib/wrt/dhcp_lease_time $out/bin/dhcp_lease_time
    install -Dm755 contrib/wrt/dhcp_release $out/bin/dhcp_release

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
    ++ optionals stdenv.isLinux [ dbus_libs libnetfilter_conntrack ];

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ eelco ];
  };
}
