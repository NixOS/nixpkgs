{ fetchurl, fetchpatch, stdenv, autoconf, libpcap, ncurses, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "jnettop-0.13.0";

  src = fetchurl {
    url = "http://jnettop.kubs.info/dist/jnettop-0.13.0.tar.gz";
    sha256 = "1855np7c4b0bqzhf1l1dyzxb90fpnvrirdisajhci5am6als31z9";
  };

  buildInputs = [ autoconf libpcap ncurses pkgconfig glib ];

  patches = [
    ./no-dns-resolution.patch
    (fetchpatch {
      url = "https://sources.debian.net/data/main/j/jnettop/0.13.0-1/debian/patches/0001-Use-64-bit-integers-for-byte-totals-support-bigger-u.patch";
      sha256 = "1b0alc12sj8pzcb66f8xslbqlbsvq28kz34v6jfhbb1q25hyr7jg";
    })
  ];

  preConfigure = '' autoconf '';

  meta = {
    description = "Network traffic visualizer";

    longDescription = ''
      Jnettop is a traffic visualiser, which captures traffic going
      through the host it is running from and displays streams sorted
      by bandwidth they use.
    '';

    homepage = http://jnettop.kubs.info/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
