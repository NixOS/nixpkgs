{ stdenv, perl, pkgs, steam-runtime
, nativeOnly ? false
, runtimeOnly ? false
}:

assert !(nativeOnly && runtimeOnly);

let 
  runtimePkgs = with pkgs; [
    # Required
    glib
    gtk2
    bzip2
    zlib
    gdk_pixbuf

    # Without these it silently fails
    xlibs.libXinerama
    xlibs.libXdamage
    xlibs.libXcursor
    xlibs.libXrender
    xlibs.libXScrnSaver
    xlibs.libXi
    xlibs.libSM
    xlibs.libICE
    gnome2.GConf
    freetype
    curl
    nspr
    nss
    fontconfig
    cairo
    pango
    expat
    dbus
    cups
    libcap
    SDL2
    libusb1
    dbus_glib
    libav
    atk
    # Only libraries are needed from those two
    udev182
    networkmanager098

    # Verified games requirements
    xlibs.libXmu
    xlibs.libxcb
    xlibs.libpciaccess
    mesa_glu
    libuuid
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    openssl
    libidn

    # Other things from runtime
    xlibs.libXinerama
    flac
    freeglut
    libjpeg
    libpng12
    libsamplerate
    libmikmod
    libtheora
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_net
    SDL2_ttf
    SDL2_mixer
    gstreamer
    gst_plugins_base
  ];

  overridePkgs = with pkgs; [
    gcc48.cc # libstdc++
    libpulseaudio
    alsaLib
    openalSoft
  ];

  ourRuntime = if runtimeOnly then []
               else if nativeOnly then runtimePkgs ++ overridePkgs
               else overridePkgs;
  steamRuntime = stdenv.lib.optional (!nativeOnly) steam-runtime;

in stdenv.mkDerivation rec {
  name = "steam-runtime-wrapped";

  allPkgs = ourRuntime ++ steamRuntime;

  nativeBuildInputs = [ perl ];

  builder = ./build-runtime.sh;

  installPhase = ''
    buildDir "${toString steam-runtime.libs}" "$allPkgs"
    buildDir "${toString steam-runtime.bins}" "$allPkgs"
  '';

  meta.hydraPlatforms = [];
}
