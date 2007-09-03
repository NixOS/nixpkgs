args:
args.stdenv.mkDerivation {
  name = "dnsmasq-2.40";

  src = args.fetchurl {
    url = http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.40.tar.gz;
    sha256 = "1q346l403rvvmvr14fk2l201p8fl3p5417vkp95zlx00jdb7hl8n";
  };

  installPhase = "ensureDir \$out; make DESTDIR=\$out PREFIX=ôônstall"; 

  buildInputs =(with args; []);

  meta = { 
      description = "DNS forwarder and DHCP server";
      homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
      license = "GPL";
    };
}
