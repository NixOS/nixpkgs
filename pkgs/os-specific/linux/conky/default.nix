{ stdenv, fetchurl, pkgconfig, libxml2, curl, wirelesstools, glib, openssl
, ncurses }:

stdenv.mkDerivation rec {
  name = "conky-1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/conky/${name}.tar.bz2";
    sha256 = "0vxvjmi3cdvnp994sv5zcdyncfn0mlxa71p2wm9zpyrmy58bbwds";
  };

  patches = [ ./stdbool.patch ];

  buildInputs = [ pkgconfig libxml2 curl wirelesstools glib openssl ncurses ];
  configureFlags =
    (map (x: "--disable-${x}") [ "x11" "xdamage" "own-window" "xft" "lua" ])
    ++ (map (x: "--enable-${x}") [ "mpd" "double-buffer" "wlan" "rss"
                                   "weather-metar" "weather-xoap" ]);

  meta = {
    homepage = http://conky.sourceforge.net/;
    description = "Conky is an advanced, highly configurable system monitor complied without X based on torsmo";
    maintainers = [ stdenv.lib.maintainers.guibert ];
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
