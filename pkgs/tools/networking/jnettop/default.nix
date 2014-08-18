{ fetchurl, stdenv, autoconf, libpcap, ncurses, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "jnettop-0.13.0";

  src = fetchurl {
    url = "http://jnettop.kubs.info/dist/jnettop-0.13.0.tar.gz";
    sha256 = "1855np7c4b0bqzhf1l1dyzxb90fpnvrirdisajhci5am6als31z9";
  };

  buildInputs = [ autoconf libpcap ncurses pkgconfig glib ];

  patches = [ ./no-dns-resolution.patch ];
  preConfigure = '' autoconf '';

  meta = {
    description = "Jnettop, a network traffic visualizer";

    longDescription = ''
      Jnettop is a traffic visualiser, which captures traffic going
      through the host it is running from and displays streams sorted
      by bandwidth they use.
    '';

    homepage = http://jnettop.kubs.info/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
