{ stdenv, fetchurl, iptables, libnfnetlink, libnetfilter_conntrack }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.7.20121005";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "03kaxj808hgj1zf2528pzilgywgh70mh0qivjb5nm3spziiq32sv";
  };

  buildInputs = [ iptables libnfnetlink libnetfilter_conntrack ];

  patchPhase = ''
    sed -i -e 's/upnputils\.o -lnfnetlink/upnputils.o/' Makefile.linux
  '';

  NIX_CFLAGS_COMPILE = "-DIPTABLES_143";

  NIX_CFLAGS_LINK = "-liptc -lnfnetlink";

  makefile = "Makefile.linux";

  makeFlags = "LIBS=";

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  preInstall =
    ''
      mkdir -p $out/share/man/man8
    '';

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
  };
}
