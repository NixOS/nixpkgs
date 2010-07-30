{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "dnsmasq-2.40";

  src = fetchurl {
    url = http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.40.tar.gz;
    sha256 = "1q346l403rvvmvr14fk2l201p8fl3p5417vkp95zlx00jdb7hl8n";
  };

  installPhase = "ensureDir \$out/bin; make DESTDIR= BINDIR=\$out/bin MANDIR=\$out/man LOCALEDIR=\$out/share/locale install"; 

  meta = { 
    description = "DNS forwarder and DHCP server";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = "GPL";
  };
}
