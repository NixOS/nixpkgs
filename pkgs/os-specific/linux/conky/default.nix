{ stdenv, fetchurl, pkgconfig

# dependencies
, glib, ncurses

# optional features without extra dependencies
, mpdSupport   ? true

# optional features with extra dependencies
, x11Support   ? false, x11           ? null
, xdamage      ? false, libXdamage    ? null
, wireless     ? false, wirelesstools ? null
, luaSupport   ? false, lua5          ? null

, rss          ? false
, weatherMetar ? false
, weatherXoap  ? false
, curl ? null, libxml2 ? null
}:

assert luaSupport -> lua5          != null;
assert wireless   -> wirelesstools != null;
assert x11Support -> x11           != null;
assert xdamage    -> x11Support && libXdamage != null;

assert rss          -> curl != null && libxml2 != null;
assert weatherMetar -> curl != null;
assert weatherXoap  -> curl != null && libxml2 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "conky-1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/conky/${name}.tar.bz2";
    sha256 = "0vxvjmi3cdvnp994sv5zcdyncfn0mlxa71p2wm9zpyrmy58bbwds";
  };

  buildInputs = [ pkgconfig glib ncurses ]
    ++ optional  luaSupport   lua5
    ++ optional  wireless     wirelesstools
    ++ optional  x11Support   x11
    ++ optional  xdamage      libXdamage

    ++ optionals rss          [ curl libxml2 ]
    ++ optional  weatherMetar curl
    ++ optionals weatherXoap  [ curl libxml2 ]
    ;

  configureFlags =
    let flag = state: flags: if state then map (x: "--enable-${x}")  flags
                                      else map (x: "--disable-${x}") flags;
     in flag mpdSupport   [ "mpd" ]

     ++ flag luaSupport   [ "lua" ]
     ++ flag wireless     [ "wlan" ]
     ++ flag x11Support   [ "x11" "xft" "argb" "double-buffer" "own-window" ] # conky won't compile without --enable-own-window
     ++ flag xdamage      [ "xdamage" ]

     ++ flag rss          [ "rss" ]
     ++ flag weatherMetar [ "weather-metar" ]
     ++ flag weatherXoap  [ "weather-xoap" ]
     ;

  meta = {
    homepage = http://conky.sourceforge.net/;
    description = "Conky is an advanced, highly configurable system monitor based on torsmo";
    maintainers = [ stdenv.lib.maintainers.guibert ];
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
