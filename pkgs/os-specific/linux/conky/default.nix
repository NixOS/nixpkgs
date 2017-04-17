{ stdenv, fetchFromGitHub, pkgconfig, cmake

# dependencies
, glib, libXinerama

# optional features without extra dependencies
, mpdSupport          ? true
, ibmSupport          ? true # IBM/Lenovo notebooks

# optional features with extra dependencies

# ouch, this is ugly, but this gives the man page
, docsSupport         ? true, docbook2x, libxslt ? null
                            , man ? null, less ? null
                            , docbook_xsl ? null , docbook_xml_dtd_44 ? null

, ncursesSupport      ? true      , ncurses       ? null
, x11Support          ? true      , xlibsWrapper           ? null
, xdamageSupport      ? x11Support, libXdamage    ? null
, doubleBufferSupport ? x11Support
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

assert docsSupport         -> docbook2x != null && libxslt != null
                           && man != null && less != null
                           && docbook_xsl != null && docbook_xml_dtd_44 != null;

assert ncursesSupport      -> ncurses != null;

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

assert wirelessSupport     -> wirelesstools != null;

assert curlSupport         -> curl != null;
assert rssSupport          -> curlSupport && libxml2 != null;
assert weatherMetarSupport -> curlSupport;
assert weatherXoapSupport  -> curlSupport && libxml2 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "conky-${version}";
  version = "1.10.6";

  src = fetchFromGitHub {
    owner = "brndnmtthws";
    repo = "conky";
    rev = "v${version}";
    sha256 = "15j8h251v9jpdg6h6wn1vb45pkk806pf9s5n3rdrps9r185w8hn8";
  };

  postPatch = ''
    sed -i -e '/include.*CheckIncludeFile)/i include(CheckIncludeFiles)' \
      cmake/ConkyPlatformChecks.cmake
  '' + optionalString docsSupport ''
    # Drop examples, since they contain non-ASCII characters that break docbook2x :(
    sed -i 's/ Example: .*$//' doc/config_settings.xml

    substituteInPlace cmake/Docbook.cmake \
      --replace "http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl" "${docbook_xsl}/xml/xsl/docbook/html/docbook.xsl"
    substituteInPlace doc/docs.xml \
      --replace "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" "${docbook_xml_dtd_44}/xml/dtd/docbook/docbookx.dtd"
    substituteInPlace cmake/Conky.cmake --replace "#set(RELEASE true)" "set(RELEASE true)"
  '';

  NIX_LDFLAGS = "-lgcc_s";

  buildInputs = [ pkgconfig glib cmake libXinerama ]
    ++ optionals docsSupport        [ docbook2x libxslt man less ]
    ++ optional  ncursesSupport     ncurses
    ++ optional  x11Support         xlibsWrapper
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

  cmakeFlags = []
    ++ optional docsSupport         "-DMAINTAINER_MODE=ON"
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
    ++ optional doubleBufferSupport "-DBUILD_XDBE=ON"
    ++ optional weatherMetarSupport "-DBUILD_WEATHER_METAR=ON"
    ++ optional weatherXoapSupport  "-DBUILD_WEATHER_XOAP=ON"
    ++ optional wirelessSupport     "-DBUILD_WLAN=ON"
    ;

  meta = with stdenv.lib; {
    homepage = http://conky.sourceforge.net/;
    description = "Advanced, highly configurable system monitor based on torsmo";
    maintainers = [ maintainers.guibert ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
