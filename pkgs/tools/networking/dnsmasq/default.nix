{ stdenv, fetchurl, pkgconfig, dbus_libs, nettle, libidn, libnetfilter_conntrack }:

with stdenv.lib;
let
  copts = concatStringsSep " " ([
    "-DHAVE_DBUS"
    "-DHAVE_IDN"
    "-DHAVE_DNSSEC"
  ] ++ optionals stdenv.isLinux [
    "-DHAVE_CONNTRACK"
  ]);
in
stdenv.mkDerivation rec {
  name = "dnsmasq-2.73";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.xz";
    sha256 = "1xnqfaw2l78f4zw4z9sgr9nl9yc233gxc3sd7hxapz2k7q883zqb";
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

  postInstall = ''
    install -Dm644 dbus/dnsmasq.conf $out/etc/dbus-1/system.d/dnsmasq.conf
    install -Dm644 trust-anchors.conf $out/share/dnsmasq/trust-anchors.conf

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
  buildInputs = [ dbus_libs nettle libidn ]
    ++ optional stdenv.isLinux libnetfilter_conntrack;

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ eelco ];
  };
}
