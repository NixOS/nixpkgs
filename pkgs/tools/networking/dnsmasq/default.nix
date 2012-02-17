{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.59";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.gz";
    sha256 = "02s1y5320aiqhcrgzc7c2zs292vidijc156k5w7apzzsk5hfdhdx";
  };

  makeFlags = "DESTDIR= BINDIR=$(out)/bin MANDIR=$(out)/man LOCALEDIR=$(out)/share/locale";

  meta = { 
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
  };
}
