{ stdenv, fetchurl, iptables, libuuid, pkgconfig }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-2.0.20180422";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "03g9r519p127sj6rl2x535022bwj8vzvdwp4385v7vnjrd4dswzy";
    name = "${name}.tar.gz";
  };

  buildInputs = [ iptables libuuid ];
  nativeBuildInputs= [ pkgconfig ];

  makefile = "Makefile.linux";

  buildFlags = [ "miniupnpd" "genuuid" ];

  installFlags = [ "PREFIX=$(out)" "INSTALLPREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://miniupnp.free.fr/;
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = platforms.linux;
  };
}
