{ stdenv, fetchurl, iptables, pkgconfig }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.9.20150721";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0w2422wfcir333qd300swkdvmksdfdllspplnz8vbv13a1724h4k";
    name = "${name}.tar.gz";
  };

  buildInputs = [ iptables ];
  nativeBuildInputs= [ pkgconfig ];

  NIX_CFLAGS_LINK = "-liptc";

  makefile = "Makefile.linux";

  buildFlags = "miniupnpd genuuid";

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = stdenv.lib.platforms.linux;
  };
}
