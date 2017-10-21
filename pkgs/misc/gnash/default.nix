{ stdenv, fetchgit, autoreconfHook
, pkgconfig, libtool, boost, SDL
, glib, pango, gettext, curl, xorg
, libpng, libjpeg, giflib, speex, atk

# renderers
, enableAGG    ? true,  agg   ? null
, enableCairo  ? false, cairo ? null
, enableOpenGL ? false, mesa  ? null

# GUI toolkits
, enableGTK ? true,  gtk2 ? null, gnome2 ? null, gnome3 ? null
, enableSDL ? false
, enableQt  ? false, qt4  ? null

# media
, enableFFmpeg    ? true,  ffmpeg_2 ? null
, enableGstreamer ? false, gst-plugins-base ? null
                         , gst-plugins-ugly ? null
                         , gst-ffmpeg ? null

# misc
, enableJemalloc ? true, jemalloc  ? null
, enableHwAccel  ? true
, enablePlugins  ? false, xulrunner ? null, npapi_sdk ? null
}:

with stdenv.lib;

let 
  available = x: x != null;

  sound =
    if enableFFmpeg    then "ffmpeg" else
    if enableGstreamer then "gst"    else "none";

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
assert enableOpenGL -> available mesa;

# GUI toolkits
assert enableGTK -> all available [ gtk2 gnome2.gtkglext gnome3.gconf ];
assert enableSDL -> available SDL;
assert enableQt  -> available qt4;

# media libraries
assert enableFFmpeg    -> available ffmpeg_2 ;
assert enableGstreamer -> all available [ gst-plugins-base gst-plugins-ugly gst-ffmpeg ];

# misc
assert enableJemalloc -> available jemalloc;
assert enableHwAccel  -> available mesa;
assert enablePlugins  -> all available [ xulrunner npapi_sdk ];

assert length toolkits  == 0 -> throw "at least one GUI toolkit must be enabled";
assert length renderers == 0 -> throw "at least one renderer must be enabled";


stdenv.mkDerivation rec {
  name = "gnash-${version}";
  version = "0.8.11-2017-03-08";

  src = fetchgit {
    url = "git://git.sv.gnu.org/gnash.git";
    rev = "8a11e60585db4ed6bc4eafadfbd9b3123ced45d9";
    sha256 = "1qas084gc4s9cb2jbwi2s1h4hk7m92xmrsb596sd14h0i44dai02";
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
    ++ optional  enableOpenGL    mesa
    ++ optional  enableQt        qt4
    ++ optional  enableFFmpeg    ffmpeg_2
    ++ optional  enableJemalloc  jemalloc
    ++ optional  enableHwAccel   mesa
    ++ optionals enablePlugins   [ xulrunner npapi_sdk ]
    ++ optionals enableGTK       [ gtk2 gnome2.gtkglext gnome3.gconf ]
    ++ optionals enableGstreamer [ gst-plugins-base gst-plugins-ugly gst-ffmpeg ];

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
