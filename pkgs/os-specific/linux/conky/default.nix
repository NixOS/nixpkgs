{ stdenv, fetchFromGitHub, pkgconfig, cmake

# dependencies
, glib

# optional features without extra dependencies
, mpdSupport          ? true
, ibmSupport          ? true # IBM/Lenovo notebooks

# optional features with extra dependencies
, ncursesSupport      ? true      , ncurses       ? null
, x11Support          ? true      , x11           ? null
, xdamageSupport      ? x11Support, libXdamage    ? null
, imlib2Support       ? x11Support, imlib2        ? null

, luaSupport          ? true      , lua           ? null
, luaImlib2Support    ? luaSupport && imlib2Support
, luaCairoSupport     ? luaSupport && x11Support, cairo ? null
, toluapp ? null

, wirelessSupport     ? true      , wirelesstools ? null

, curlSupport         ? true      , curl ? null
, rssSupport          ? curlSupport
, weatherMetarSupport ? curlSupport
, weatherXoapSupport  ? curlSupport
, libxml2 ? null
}:

assert ncursesSupport      -> ncurses != null;

assert x11Support          -> x11 != null;
assert xdamageSupport      -> x11Support && libXdamage != null;
assert imlib2Support       -> x11Support && imlib2     != null;
assert luaSupport          -> lua != null;
assert luaImlib2Support    -> luaSupport && imlib2Support
                                         && toluapp != null;
assert luaCairoSupport     -> luaSupport && toluapp != null
                                         && cairo   != null;
assert luaCairoSupport || luaImlib2Support
                           -> lua.luaversion == "5.1";

assert wirelessSupport     -> wirelesstools != null;

assert curlSupport         -> curl != null;
assert rssSupport          -> curlSupport && libxml2 != null;
assert weatherMetarSupport -> curlSupport;
assert weatherXoapSupport  -> curlSupport && libxml2 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "conky-${version}";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "brndnmtthws";
    repo = "conky";
    rev = "v${version}";
    sha256 = "00vyrf72l54j3majqmn6vykqvvb15vygsaby644nsb5vpma6b1cn";
  };

  NIX_LDFLAGS = "-lgcc_s";

  buildInputs = [ pkgconfig glib cmake ]
    ++ optional  ncursesSupport     ncurses
    ++ optional  x11Support         x11
    ++ optional  xdamageSupport     libXdamage
    ++ optional  imlib2Support      imlib2
    ++ optional  luaSupport         lua
    ++ optionals luaImlib2Support   [ toluapp imlib2 ]
    ++ optionals luaCairoSupport    [ toluapp cairo ]
    ++ optional  wirelessSupport    wirelesstools
    ++ optional  curlSupport        curl
    ++ optional  rssSupport         libxml2
    ++ optional  weatherXoapSupport libxml2
    ;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ optional curlSupport         "-DBUILD_CURL=ON"
    ++ optional (!ibmSupport)       "-DBUILD_IBM=OFF"
    ++ optional imlib2Support       "-DBUILD_IMLIB2=ON"
    ++ optional luaCairoSupport     "-DBUILD_LUA_CAIRO=ON"
    ++ optional luaImlib2Support    "-DBUILD_LUA_IMLIB2=ON"
    ++ optional (!mpdSupport)       "-DBUILD_MPD=OFF"
    ++ optional (!ncursesSupport)   "-DBUILD_NCURSES=OFF"
    ++ optional rssSupport          "-DBUILD_RSS=ON"
    ++ optional (!x11Support)       "-DBUILD_X11=OFF"
    ++ optional xdamageSupport      "-DBUILD_XDAMAGE=ON"
    ++ optional weatherMetarSupport "-DBUILD_WEATHER_METAR=ON"
    ++ optional weatherXoapSupport  "-DBUILD_WEATHER_XOAP=ON"
    ++ optional wirelessSupport     "-DBUILD_WLAN=ON"
    ;

  meta = with stdenv.lib; {
    homepage = http://conky.sourceforge.net/;
    description = "Advanced, highly configurable system monitor based on torsmo";
    maintainers = [ maintainers.guibert ];
    license = licenses.gpl3Plus;
  };
}
