{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.55";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.gz";
    sha256 = "0agrz7lvqdvh7ps173nr5yl00dblv2lpd0x9pm64f03zjzsyqqyg";
  };

  makeFlags = "DESTDIR= BINDIR=$(out)/bin MANDIR=$(out)/man LOCALEDIR=$(out)/share/locale";

  meta = { 
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
  };
}
