{ config, lib, stdenv, fetchFromGitHub, pkg-config, cmake

# dependencies
, glib, libXinerama, catch2

# optional features without extra dependencies
, mpdSupport          ? true
, ibmSupport          ? true # IBM/Lenovo notebooks

# optional features with extra dependencies

# ouch, this is ugly, but this gives the man page
, docsSupport         ? true, docbook2x, libxslt ? null
                            , man ? null, less ? null
                            , docbook_xsl ? null , docbook_xml_dtd_44 ? null

, ncursesSupport      ? true      , ncurses       ? null
, x11Support          ? true      , freetype, xorg
, xdamageSupport      ? x11Support, libXdamage    ? null
, doubleBufferSupport ? x11Support
, imlib2Support       ? x11Support, imlib2        ? null

, luaSupport          ? true      , lua           ? null
, luaImlib2Support    ? luaSupport && imlib2Support
, luaCairoSupport     ? luaSupport && x11Support, cairo ? null
, toluapp ? null

, wirelessSupport     ? true      , wirelesstools ? null
, nvidiaSupport       ? false     , libXNVCtrl ? null
, pulseSupport        ? config.pulseaudio or false, libpulseaudio ? null

, curlSupport         ? true      , curl ? null
, rssSupport          ? curlSupport
, weatherMetarSupport ? curlSupport
, weatherXoapSupport  ? curlSupport
, journalSupport      ? true, systemd ? null
, libxml2 ? null
}:

assert docsSupport         -> docbook2x != null && libxslt != null
                           && man != null && less != null
                           && docbook_xsl != null && docbook_xml_dtd_44 != null;

assert ncursesSupport      -> ncurses != null;

assert xdamageSupport      -> x11Support && libXdamage != null;
assert imlib2Support       -> x11Support && imlib2     != null;
assert luaSupport          -> lua != null;
assert luaImlib2Support    -> luaSupport && imlib2Support
                                         && toluapp != null;
assert luaCairoSupport     -> luaSupport && toluapp != null
                                         && cairo   != null;
assert luaCairoSupport || luaImlib2Support
                           -> lua.luaversion == "5.3";

assert wirelessSupport     -> wirelesstools != null;
assert nvidiaSupport       -> libXNVCtrl != null;
assert pulseSupport        -> libpulseaudio != null;

assert curlSupport         -> curl != null;
assert rssSupport          -> curlSupport && libxml2 != null;
assert weatherMetarSupport -> curlSupport;
assert weatherXoapSupport  -> curlSupport && libxml2 != null;
assert journalSupport      -> systemd != null;

stdenv.mkDerivation rec {
  pname = "conky";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "brndnmtthws";
    repo = "conky";
    rev = "v${version}";
    sha256 = "sha256-3eCRzjfHGFiKuxmRHvnzqAg/+ApUKnHhsumWnio/Qxg=";
  };

  postPatch = ''
    sed -i -e '/include.*CheckIncludeFile)/i include(CheckIncludeFiles)' \
      cmake/ConkyPlatformChecks.cmake
  '' + lib.optionalString docsSupport ''
    # Drop examples, since they contain non-ASCII characters that break docbook2x :(
    sed -i 's/ Example: .*$//' doc/config_settings.xml

    substituteInPlace cmake/Conky.cmake --replace "# set(RELEASE true)" "set(RELEASE true)"

    cp ${catch2}/include/catch2/catch.hpp tests/catch2/catch.hpp
  '';

  NIX_LDFLAGS = "-lgcc_s";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ glib libXinerama ]
    ++ lib.optionals docsSupport        [ docbook2x docbook_xsl docbook_xml_dtd_44 libxslt man less ]
    ++ lib.optional  ncursesSupport     ncurses
    ++ lib.optionals x11Support         [ freetype xorg.libICE xorg.libX11 xorg.libXext xorg.libXft xorg.libSM ]
    ++ lib.optional  xdamageSupport     libXdamage
    ++ lib.optional  imlib2Support      imlib2
    ++ lib.optional  luaSupport         lua
    ++ lib.optionals luaImlib2Support   [ toluapp imlib2 ]
    ++ lib.optionals luaCairoSupport    [ toluapp cairo ]
    ++ lib.optional  wirelessSupport    wirelesstools
    ++ lib.optional  curlSupport        curl
    ++ lib.optional  rssSupport         libxml2
    ++ lib.optional  weatherXoapSupport libxml2
    ++ lib.optional  nvidiaSupport      libXNVCtrl
    ++ lib.optional  pulseSupport       libpulseaudio
    ++ lib.optional  journalSupport     systemd
    ;

  cmakeFlags = []
    ++ lib.optional docsSupport         "-DMAINTAINER_MODE=ON"
    ++ lib.optional curlSupport         "-DBUILD_CURL=ON"
    ++ lib.optional (!ibmSupport)       "-DBUILD_IBM=OFF"
    ++ lib.optional imlib2Support       "-DBUILD_IMLIB2=ON"
    ++ lib.optional luaCairoSupport     "-DBUILD_LUA_CAIRO=ON"
    ++ lib.optional luaImlib2Support    "-DBUILD_LUA_IMLIB2=ON"
    ++ lib.optional (!mpdSupport)       "-DBUILD_MPD=OFF"
    ++ lib.optional (!ncursesSupport)   "-DBUILD_NCURSES=OFF"
    ++ lib.optional rssSupport          "-DBUILD_RSS=ON"
    ++ lib.optional (!x11Support)       "-DBUILD_X11=OFF"
    ++ lib.optional xdamageSupport      "-DBUILD_XDAMAGE=ON"
    ++ lib.optional doubleBufferSupport "-DBUILD_XDBE=ON"
    ++ lib.optional weatherMetarSupport "-DBUILD_WEATHER_METAR=ON"
    ++ lib.optional weatherXoapSupport  "-DBUILD_WEATHER_XOAP=ON"
    ++ lib.optional wirelessSupport     "-DBUILD_WLAN=ON"
    ++ lib.optional nvidiaSupport       "-DBUILD_NVIDIA=ON"
    ++ lib.optional pulseSupport        "-DBUILD_PULSEAUDIO=ON"
    ++ lib.optional journalSupport      "-DBUILD_JOURNAL=ON"
    ;

  # `make -f src/CMakeFiles/conky.dir/build.make src/CMakeFiles/conky.dir/conky.cc.o`:
  # src/conky.cc:137:23: fatal error: defconfig.h: No such file or directory
  enableParallelBuilding = false;

  doCheck = true;

  meta = with lib; {
    homepage = "http://conky.sourceforge.net/";
    description = "Advanced, highly configurable system monitor based on torsmo";
    maintainers = [ maintainers.guibert ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
