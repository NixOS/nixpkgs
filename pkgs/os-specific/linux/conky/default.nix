{stdenv, fetchurl, pkgconfig, libxml2, curl, wirelesstools, glib, openssl}:

stdenv.mkDerivation rec {
  name = "conky-1.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/conky/${name}.tar.bz2";
    sha256 = "0hsybra4qzaqzny6n66m7768vbwkikajcvcbsqgnnnb9527jfnpq";
  };

  buildInputs = [ pkgconfig libxml2 curl wirelesstools glib openssl ];
  configureFlags =
    (map (x: "--disable-${x}") [ "x11" "xdamage" "own-window" "xft" "lua" "ncurses" ])
    ++ (map (x: "--enable-${x}") [ "mpd" "double-buffer" "wlan" "rss" ]);

  patches = [ ./curl-types-h.patch ];

  meta = {
    homepage = http://conky.sourceforge.net/;
    description = "Conky is an advanced, highly configurable system monitor complied without X based on torsmo";
    maintainers = [ stdenv.lib.maintainers.guibert ];
  };
}

