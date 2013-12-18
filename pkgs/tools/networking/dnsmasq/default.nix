{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.68";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.gz";
    sha256 = "0bvw16i83ybiajskma59zjiqw59vzlcqf8f69k0crwak3zb1j820";
  };

  makeFlags = "DESTDIR= BINDIR=$(out)/bin MANDIR=$(out)/man LOCALEDIR=$(out)/share/locale";

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
