{ pkgconfig, dbus_libs, nettle, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.71";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.xz";
    sha256 = "1fpzpzja7qr8b4kfdhh4i4sijp62c634yf0xvq2n4p7d5xbzn6a9";
  };

  # Can't rely on make flags because of space in one of the parameters
  buildPhase = ''
    make COPTS="-DHAVE_DNSSEC -DHAVE_DBUS"
  '';

  # make flags used for installation only
  makeFlags = "DESTDIR= BINDIR=$(out)/bin MANDIR=$(out)/man LOCALEDIR=$(out)/share/locale";

  postInstall = ''
    install -Dm644 dbus/dnsmasq.conf $out/etc/dbus-1/system.d/dnsmasq.conf
    install -Dm644 trust-anchors.conf $out/share/dnsmasq/trust-anchors.conf

    ensureDir $out/share/dbus-1/system-services
    cat <<END > $out/share/dbus-1/system-services/uk.org.thekelleys.dnsmasq.service
    [D-BUS Service]
    Name=uk.org.thekelleys.dnsmasq
    Exec=$out/sbin/dnsmasq -k -1
    User=root
    SystemdService=dnsmasq.service
    END
  '';

  buildInputs = [ pkgconfig dbus_libs nettle ];

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
