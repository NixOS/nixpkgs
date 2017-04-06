{ stdenv, lib, perl, pkgs, steam-runtime
, nativeOnly ? false
, runtimeOnly ? false
, newStdcpp ? false
}:

assert !(nativeOnly && runtimeOnly);
assert newStdcpp -> !runtimeOnly;

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
    xlibs.libXxf86vm
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
    libudev0-shim
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
    gst-plugins-base
  ] ++ lib.optional (!newStdcpp) gcc48.cc;

  overridePkgs = with pkgs; [
    libgpgerror
    libpulseaudio
    alsaLib
    openalSoft
    libva
    vulkan-loader
  ] ++ lib.optional newStdcpp gcc.cc;

  ourRuntime = if runtimeOnly then []
               else if nativeOnly then runtimePkgs ++ overridePkgs
               else overridePkgs;
  steamRuntime = lib.optional (!nativeOnly) steam-runtime;

  allPkgs = ourRuntime ++ steamRuntime;

in stdenv.mkDerivation rec {
  name = "steam-runtime-wrapped";

  nativeBuildInputs = [ perl ];

  builder = ./build-wrapped.sh;

  installPhase = ''
    buildDir "${toString steam-runtime.libs}" "${toString (map lib.getLib allPkgs)}"
    buildDir "${toString steam-runtime.bins}" "${toString (map lib.getBin allPkgs)}"
  '';

  meta.hydraPlatforms = [];
}
