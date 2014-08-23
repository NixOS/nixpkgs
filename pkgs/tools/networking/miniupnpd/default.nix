{ stdenv, fetchurl, iptables, libnfnetlink }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.8.20140401";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "1gfdbfqcw6ih830si51yzqbyymgcbwkiv9vk5dwnxs78b7xgyv88";
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
