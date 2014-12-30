{ stdenv, fetchurl, iptables, libnfnetlink }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.9";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/${name}.tar.gz";
    sha256 = "1b52pcbs5hi8680wkn3klxgk60shpp5jripiivk7waj2lqhynxk1";
  };

  buildInputs = [ iptables libnfnetlink ];

  NIX_CFLAGS_COMPILE = "-DIPTABLES_143";

  NIX_CFLAGS_LINK = "-liptc -lnfnetlink";

  makefile = "Makefile.linux";

  makeFlags = "LIBS=";

  buildFlags = "miniupnpd genuuid";

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
  };
}
