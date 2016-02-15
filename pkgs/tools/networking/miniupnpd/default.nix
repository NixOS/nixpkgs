{ stdenv, fetchurl, iptables, libuuid, pkgconfig }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.9.20160212";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "1fsl46f7lrhpb597m0a905nwijpf188cchgg6pz39fx2mgjjjk9l";
    name = "${name}.tar.gz";
  };

  buildInputs = [ iptables libuuid ];
  nativeBuildInputs= [ pkgconfig ];

  makefile = "Makefile.linux";

  buildFlags = "miniupnpd genuuid";

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = stdenv.lib.platforms.linux;
  };
}
