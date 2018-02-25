{ stdenv, steamArch, lib, perl, pkgs, steam-runtime
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
    xlibs.libXxf86vm
    xlibs.libXi
    xlibs.libSM
    xlibs.libICE
    gnome2.GConf
    freetype
    (curl.override { gnutlsSupport = true; sslSupport = false; })
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
    dbus-glib
    libav
    atk
    # Only libraries are needed from those two
    libudev0-shim
    networkmanager098

    # Verified games requirements
    xlibs.libXmu
    xlibs.libxcb
    mesa_glu
    libuuid
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    openssl
    libidn
    tbb

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
  ];

  overridePkgs = with pkgs; [
    libgpgerror
    libpulseaudio
    alsaLib
    openalSoft
    libva
    vulkan-loader
    gcc.cc
    nss
    nspr
  ];

  ourRuntime = if runtimeOnly then []
               else if nativeOnly then runtimePkgs ++ overridePkgs
               else overridePkgs;
  steamRuntime = lib.optional (!nativeOnly) steam-runtime;

  allPkgs = ourRuntime ++ steamRuntime;

  gnuArch = if steamArch == "amd64" then "x86_64-linux-gnu"
            else if steamArch == "i386" then "i386-linux-gnu"
            else abort "Unsupported architecture";

  libs = [ "lib/${gnuArch}" "lib" "usr/lib/${gnuArch}" "usr/lib" ];
  bins = [ "bin" "usr/bin" ];

in stdenv.mkDerivation rec {
  name = "steam-runtime-wrapped";

  nativeBuildInputs = [ perl ];

  builder = ./build-wrapped.sh;

  passthru = {
    inherit gnuArch libs bins;
    arch = steamArch;
  };

  installPhase = ''
    buildDir "${toString libs}" "${toString (map lib.getLib allPkgs)}"
    buildDir "${toString bins}" "${toString (map lib.getBin allPkgs)}"
  '';
}
