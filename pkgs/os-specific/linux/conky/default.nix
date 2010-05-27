{stdenv, fetchurl, pkgconfig, libxml2, curl, wirelesstools, glib, openssl}:

stdenv.mkDerivation {
  name = "conky-1.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/conky/conky-1.7.2.tar.bz2";
    sha256 = "0p375id2saxm2bp6c33ddn9d6rxymmq60ajlvx49smwhzyqa3h5k";
  };

  buildInputs = [ pkgconfig libxml2 curl wirelesstools glib openssl ];
  configureFlags = "--disable-x11 --disable-xdamage --disable-own-window --disable-xft --disable-lua --enable-mpd --enable-double-buffer --enable-proc-uptime --enable-seti --enable-wlan --enable-rss";

  meta = {
    homepage = http://conky.sourceforge.net/;
    description = "Conky is an advanced, highly configurable system monitor complied without X based on torsmo";
    maintainers = [ stdenv.lib.maintainers.guibert ];
  };
}

