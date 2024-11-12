{ config, lib, stdenv, fetchFromGitHub, pkg-config, cmake

# dependencies
, glib, libXinerama, catch2

# lib.optional features without extra dependencies
, mpdSupport          ? true
, ibmSupport          ? true # IBM/Lenovo notebooks

# lib.optional features with extra dependencies

# ouch, this is ugly, but this gives the man page
, docsSupport         ? true, docbook2x, libxslt ? null
                            , man ? null, less ? null
                            , docbook_xsl ? null , docbook_xml_dtd_44 ? null

, ncursesSupport      ? true      , ncurses       ? null
, x11Support          ? true      , freetype, xorg
, waylandSupport      ? true      , pango, wayland, wayland-protocols, wayland-scanner
, xdamageSupport      ? x11Support, libXdamage    ? null
, doubleBufferSupport ? x11Support
, imlib2Support       ? x11Support, imlib2        ? null

, luaSupport          ? true      , lua           ? null
, luaImlib2Support    ? luaSupport && imlib2Support
, luaCairoSupport     ? luaSupport && (x11Support || waylandSupport), cairo ? null
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
                           -> lua.luaversion == "5.4";

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
  version = "1.19.6";

  src = fetchFromGitHub {
    owner = "brndnmtthws";
    repo = "conky";
    rev = "v${version}";
    hash = "sha256-L8YSbdk+qQl17L4IRajFD/AEWRXb2w7xH9sM9qPGrQo=";
  };

  postPatch = lib.optionalString docsSupport ''
    substituteInPlace cmake/Conky.cmake --replace "# set(RELEASE true)" "set(RELEASE true)"

    cp ${catch2}/include/catch2/catch.hpp tests/catch2/catch.hpp
  '' + lib.optionalString waylandSupport ''
    substituteInPlace src/CMakeLists.txt \
      --replace 'COMMAND ''${Wayland_SCANNER}' 'COMMAND wayland-scanner'
  '';

  env = {
    # For some reason -Werror is on by default, causing the project to fail compilation.
    NIX_CFLAGS_COMPILE = "-Wno-error";
    NIX_LDFLAGS = "-lgcc_s";
  };

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals docsSupport        [ docbook2x docbook_xsl docbook_xml_dtd_44 libxslt man less ]
    ++ lib.optional  waylandSupport     wayland-scanner
    ++ lib.optional  luaImlib2Support   toluapp
    ++ lib.optional  luaCairoSupport    toluapp
    ;
  buildInputs = [ glib libXinerama ]
    ++ lib.optional  ncursesSupport     ncurses
    ++ lib.optionals x11Support         [ freetype xorg.libICE xorg.libX11 xorg.libXext xorg.libXft xorg.libSM ]
    ++ lib.optionals waylandSupport     [ pango wayland wayland-protocols ]
    ++ lib.optional  xdamageSupport     libXdamage
    ++ lib.optional  imlib2Support      imlib2
    ++ lib.optional  luaSupport         lua
    ++ lib.optional  luaImlib2Support   imlib2
    ++ lib.optional  luaCairoSupport    cairo
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
    ++ lib.optional waylandSupport      "-DBUILD_WAYLAND=ON"
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
    homepage = "https://conky.cc";
    changelog = "https://github.com/brndnmtthws/conky/releases/tag/v${version}";
    description = "Advanced, highly configurable system monitor based on torsmo";
    mainProgram = "conky";
    maintainers = [ maintainers.guibert ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
