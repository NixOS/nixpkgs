{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.71";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.xz";
    sha256 = "1fpzpzja7qr8b4kfdhh4i4sijp62c634yf0xvq2n4p7d5xbzn6a9";
  };

  makeFlags = "DESTDIR= BINDIR=$(out)/bin MANDIR=$(out)/man LOCALEDIR=$(out)/share/locale";

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
