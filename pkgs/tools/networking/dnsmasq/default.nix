{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.71";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.gz";
    sha256 = "1i1l2s2bcs6yx05wh1p2rf4bl0jfdgmg77b33gh44r1rdbv6933x";
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
