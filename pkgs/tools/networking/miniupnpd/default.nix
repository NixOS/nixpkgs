{ stdenv, fetchurl, iptables, pkgconfig }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.9.20151212";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "1ay7dw1y5fqgjrqa9s8av8ndmw7wkjm39xnnzzw8pxbv70d6b12j";
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
