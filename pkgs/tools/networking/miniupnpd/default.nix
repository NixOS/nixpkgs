{ stdenv, fetchurl, iptables, libnfnetlink }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.9.20150430";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0ajqs3lf2cgq5fm1v79fa23sbb623i89sqnx7d9cnqbqq5py1k71";
    name = "miniupnpd-1.9.20150430.tar.gz";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
