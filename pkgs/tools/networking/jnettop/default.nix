{ fetchurl, fetchpatch, lib, stdenv, autoconf, libpcap, ncurses, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "jnettop";
  version = "0.13.0";

  src = fetchurl {
    url = "http://jnettop.kubs.info/dist/jnettop-${version}.tar.gz";
    sha256 = "1855np7c4b0bqzhf1l1dyzxb90fpnvrirdisajhci5am6als31z9";
  };

  nativeBuildInputs = [ pkg-config autoconf ];
  buildInputs = [ libpcap ncurses glib ];

  patches = [
    ./no-dns-resolution.patch
    (fetchpatch {
      url = "https://sources.debian.net/data/main/j/jnettop/0.13.0-1/debian/patches/0001-Use-64-bit-integers-for-byte-totals-support-bigger-u.patch";
      sha256 = "1b0alc12sj8pzcb66f8xslbqlbsvq28kz34v6jfhbb1q25hyr7jg";
    })

    # Fix pending upstream inclusion for ncurses-6.3:
    #  https://sourceforge.net/p/jnettop/patches/5/
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://sourceforge.net/p/jnettop/patches/5/attachment/jnettop-0.13.0-ncurses-6.3.patch";
      sha256 = "1a0g3bal6f2fh1sq9q5kfwljrnskfvrhdzhjadcds34gzsr26v7x";
    })
  ];

  preConfigure = "autoconf ";

  meta = {
    description = "Network traffic visualizer";

    longDescription = ''
      Jnettop is a traffic visualiser, which captures traffic going
      through the host it is running from and displays streams sorted
      by bandwidth they use.
    '';

    homepage = "https://sourceforge.net/projects/jnettop/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "jnettop";
  };
}
