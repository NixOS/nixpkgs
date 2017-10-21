{ stdenv, fetchurl, iptables, libuuid, pkgconfig }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-2.0";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "1dxzhvkylrnbkd5srb9rb2g4f9ydd1zbjg5sdf190m0g1sha6snr";
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
    maintainers = with maintainers; [ nckx ];
  };
}
