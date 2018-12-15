{ stdenv, writeScript, buildFHSUserEnv, coreutils, file, libarchive
, extraPkgs ? pkgs: [] }:

buildFHSUserEnv {
  name = "appimage-run";

  # Most of the packages were taken from the Steam chroot
  targetPkgs = pkgs: with pkgs; [
    gtk3
    bashInteractive
    gnome3.zenity
    python2
    xorg.xrandr
    which
    perl
    xdg_utils
    iana-etc
  ] ++ extraPkgs pkgs;

  multiPkgs = pkgs: with pkgs; [
    desktop-file-utils
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-ugly
    libdrm
    xorg.xkeyboardconfig
    xorg.libpciaccess

    glib
    gtk2
    bzip2
    zlib
    gdk_pixbuf

    xorg.libXinerama
    xorg.libXdamage
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXxf86vm
    xorg.libXi
    xorg.libSM
    xorg.libICE
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
    udev
    dbus-glib
    libav
    atk
    at-spi2-atk
    libudev0-shim
    networkmanager098

    xorg.libXt
    xorg.libXmu
    xorg.libxcb
    libGLU
    libuuid
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    openssl
    libidn
    tbb
    wayland
    mesa_noglu
    libxkbcommon

    flac
    freeglut
    libjpeg
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    gstreamer
    gst-plugins-base
    libappindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    xorg.libXft
    libvdpau
    alsaLib
    strace
  ];

  runScript = writeScript "appimage-exec" ''
    #!${stdenv.shell}
    APPIMAGE="$(realpath "$1")"

    if [ ! -x "$APPIMAGE" ]; then
      echo "fatal: $APPIMAGE is not executable"
      exit 1
    fi

    SHA256="$(${coreutils}/bin/sha256sum "$APPIMAGE" | cut -d ' ' -f 1)"
    SQUASHFS_ROOT="''${XDG_CACHE_HOME:-$HOME/.cache}/appimage-run/$SHA256/"
    mkdir -p "$SQUASHFS_ROOT"

    export APPDIR="$SQUASHFS_ROOT/squashfs-root"
    if [ ! -x "$APPDIR" ]; then
      cd "$SQUASHFS_ROOT"

      if ${file}/bin/file --mime-type --brief --keep-going "$APPIMAGE" | grep -q iso; then
        # is type-1 appimage
        mkdir "$APPDIR"
        ${libarchive}/bin/bsdtar -x -C "$APPDIR" -f "$APPIMAGE"
      else
        # is type-2 appimage
        "$APPIMAGE" --appimage-extract 2>/dev/null
      fi
    fi

    cd "$APPDIR"
    export PATH="$PATH:$PWD/usr/bin"
    export APPIMAGE_SILENT_INSTALL=1

    if [ -n "$APPIMAGE_DEBUG_EXEC" ]; then
      exec "$APPIMAGE_DEBUG_EXEC"
    fi

    exec ./AppRun
  '';
}
