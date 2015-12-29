{ stdenv, fetchurl, pkgconfig

# dependencies
, glib

# optional features without extra dependencies
, mpdSupport          ? true
, ibmSupport          ? true # IBM/Lenovo notebooks

# This should be optional, but it is not due to a bug in conky
# Please, try to make it optional again on update
, ncurses
#, ncursesSupport      ? true      , ncurses       ? null

# optional features with extra dependencies
, x11Support          ? true      , xlibsWrapper           ? null
, xdamageSupport      ? x11Support, libXdamage    ? null
, imlib2Support       ? x11Support, imlib2        ? null
, luaSupport          ? true      , lua           ? null

, luaImlib2Support    ? luaSupport && imlib2Support
, luaCairoSupport     ? luaSupport && x11Support, cairo ? null
, toluapp ? null

, alsaSupport         ? true      , alsaLib       ? null

, wirelessSupport     ? true      , wirelesstools ? null

, curlSupport         ? true      , curl ? null
, rssSupport          ? curlSupport
, weatherMetarSupport ? curlSupport
, weatherXoapSupport  ? curlSupport
, libxml2 ? null
}:

#assert ncursesSupport      -> ncurses != null;

assert x11Support          -> xlibsWrapper != null;
assert xdamageSupport      -> x11Support && libXdamage != null;
assert imlib2Support       -> x11Support && imlib2     != null;
assert luaSupport          -> lua != null;
assert luaImlib2Support    -> luaSupport && imlib2Support
                                         && toluapp != null;
assert luaCairoSupport     -> luaSupport && toluapp != null
                                         && cairo   != null;
assert luaCairoSupport || luaImlib2Support
                           -> lua.luaversion == "5.1";

assert alsaSupport         -> alsaLib != null;

assert wirelessSupport     -> wirelesstools != null;

assert curlSupport         -> curl != null;
assert rssSupport          -> curlSupport && libxml2 != null;
assert weatherMetarSupport -> curlSupport;
assert weatherXoapSupport  -> curlSupport && libxml2 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "conky-1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/conky/${name}.tar.bz2";
    sha256 = "0vxvjmi3cdvnp994sv5zcdyncfn0mlxa71p2wm9zpyrmy58bbwds";
  };

  NIX_LDFLAGS = "-lgcc_s";

  buildInputs = [ pkgconfig glib ]
    ++ [ ncurses ]
    #++ optional  ncursesSupport     ncurses
    ++ optional  x11Support         xlibsWrapper
    ++ optional  xdamageSupport     libXdamage
    ++ optional  imlib2Support      imlib2
    ++ optional  luaSupport         lua
    ++ optionals luaImlib2Support   [ toluapp imlib2 ]
    ++ optionals luaCairoSupport    [ toluapp cairo ]

    ++ optional  alsaSupport        alsaLib

    ++ optional  wirelessSupport    wirelesstools

    ++ optional  curlSupport        curl
    ++ optional  rssSupport         libxml2
    ++ optional  weatherXoapSupport libxml2
    ;

  configureFlags =
    let flag = state: flags: if state then map (x: "--enable-${x}")  flags
                                      else map (x: "--disable-${x}") flags;
     in flag mpdSupport          [ "mpd" ]
     ++ flag ibmSupport          [ "ibm" ]

     #++ flag ncursesSupport      [ "ncurses" ]
     ++ flag x11Support          [ "x11" "xft" "argb" "double-buffer" "own-window" ] # conky won't compile without --enable-own-window
     ++ flag xdamageSupport      [ "xdamage" ]
     ++ flag imlib2Support       [ "imlib2" ]
     ++ flag luaSupport          [ "lua" ]
     ++ flag luaImlib2Support    [ "lua-imlib2" ]
     ++ flag luaCairoSupport     [ "lua-cairo" ]

     ++ flag alsaSupport         [ "alsa" ]

     ++ flag wirelessSupport     [ "wlan" ]

     ++ flag curlSupport         [ "curl" ]
     ++ flag rssSupport          [ "rss" ]
     ++ flag weatherMetarSupport [ "weather-metar" ]
     ++ flag weatherXoapSupport  [ "weather-xoap" ]
     ;

  meta = {
    homepage = http://conky.sourceforge.net/;
    description = "Advanced, highly configurable system monitor based on torsmo";
    maintainers = [ stdenv.lib.maintainers.guibert ];
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
