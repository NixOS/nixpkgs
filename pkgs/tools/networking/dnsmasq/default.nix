{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dnsmasq-2.57";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.gz";
    sha256 = "1bpq1wsc7cs1nqs7abhn96nxmdncdf7c58987f9kdmi246wcgq62";
  };

  makeFlags = "DESTDIR= BINDIR=$(out)/bin MANDIR=$(out)/man LOCALEDIR=$(out)/share/locale";

  meta = { 
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
  };
}
