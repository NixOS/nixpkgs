{ stdenv, fetchgit, autoreconfHook
, pkgconfig, libtool, boost, SDL
, glib, pango, gettext, curl, xorg
, libpng, libjpeg, giflib, speex, atk

# renderers
, enableAGG    ? true,  agg   ? null
, enableCairo  ? false, cairo ? null
, enableOpenGL ? false, libGLU_combined  ? null

# GUI toolkits
, enableGTK ? true,  gtk2 ? null, gnome2 ? null
, enableSDL ? false
, enableQt  ? false, qt4  ? null

# media
, enableFFmpeg   ? true, ffmpeg_2 ? null

# misc
, enableJemalloc ? true, jemalloc ? null
, enableHwAccel  ? true
, enablePlugins  ? false, xulrunner ? null, npapi_sdk ? null
}:

with stdenv.lib;

let
  available = x: x != null;

  sound =
    if enableFFmpeg then "ffmpeg" else "none";

  renderers = []
    ++ optional enableAGG    "agg"
    ++ optional enableCairo  "cairo"
    ++ optional enableOpenGL "opengl";

  toolkits = []
    ++ optional enableGTK "gtk"
    ++ optional enableSDL "sdl"
    ++ optional enableQt  "qt4";

in

# renderers
assert enableAGG    -> available agg;
assert enableCairo  -> available cairo;
assert enableOpenGL -> available libGLU_combined;

# GUI toolkits
assert enableGTK -> all available [ gtk2 gnome2.gtkglext gnome2.GConf ];
assert enableSDL -> available SDL;
assert enableQt  -> available qt4;

# media libraries
assert enableFFmpeg    -> available ffmpeg_2 ;

# misc
assert enableJemalloc -> available jemalloc;
assert enableHwAccel  -> available libGLU_combined;
assert enablePlugins  -> all available [ xulrunner npapi_sdk ];

assert length toolkits  == 0 -> throw "at least one GUI toolkit must be enabled";
assert length renderers == 0 -> throw "at least one renderer must be enabled";


stdenv.mkDerivation rec {
  name = "gnash-${version}";
  version = "0.8.11-2019-30-01";

  src = fetchgit {
    url = "git://git.sv.gnu.org/gnash.git";
    rev = "583ccbc1275c7701dc4843ec12142ff86bb305b4";
    sha256 = "0fh0bljn0i6ypyh6l99afi855p7ki7lm869nq1qj6k8hrrwhmfry";
  };

  postPatch = ''
    sed -i 's|jemalloc.h|jemalloc/jemalloc.h|' libbase/jemalloc_gnash.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];
  buildInputs = [
    glib gettext boost curl SDL speex
    xorg.libXmu xorg.libSM xorg.libXt
    libpng libjpeg giflib pango atk
  ] ++ optional  enableAGG       agg
    ++ optional  enableCairo     cairo
    ++ optional  enableOpenGL    libGLU_combined
    ++ optional  enableQt        qt4
    ++ optional  enableFFmpeg    ffmpeg_2
    ++ optional  enableJemalloc  jemalloc
    ++ optional  enableHwAccel   libGLU_combined
    ++ optionals enablePlugins   [ xulrunner npapi_sdk ]
    ++ optionals enableGTK       [ gtk2 gnome2.gtkglext gnome2.GConf ];

  configureFlags = with stdenv.lib; [
    "--with-boost-incl=${boost.dev}/include"
    "--with-boost-lib=${boost.out}/lib"
    "--enable-renderer=${concatStringsSep "," renderers}"
    "--enable-gui=${concatStringsSep "," toolkits}"
    "--enable-media=${sound}"
    "--with-npapi-install=prefix"
    (enableFeature enablePlugins  "plugins")
    (enableFeature enableJemalloc "jemalloc")
    (optionalString enableHwAccel "--enable-device=egl")
  ];

  meta = {
    homepage    = https://savannah.gnu.org/projects/gnash;
    description = "A flash (SWF) player and browser plugin";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
