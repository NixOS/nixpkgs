{ lib, buildFHSUserEnv, config }:

buildFHSUserEnv {
  name = "steam";

  targetPkgs = pkgs:
    [ pkgs.steam-original
      # Errors in output without those
      pkgs.pciutils
      pkgs.python2
      # Games' dependencies
      pkgs.xlibs.xrandr
      pkgs.which
    ]
    ++ lib.optional (config.steam.java or false) pkgs.jdk
    ++ lib.optional (config.steam.primus or false) pkgs.primus
    ;

  multiPkgs = pkgs:
    [ # These are required by steam with proper errors
      pkgs.xlibs.libXcomposite
      pkgs.xlibs.libXtst
      pkgs.xlibs.libXrandr
      pkgs.xlibs.libXext
      pkgs.xlibs.libX11
      pkgs.xlibs.libXfixes

      pkgs.glib
      pkgs.gtk2
      pkgs.bzip2
      pkgs.zlib
      pkgs.libpulseaudio
      pkgs.gdk_pixbuf

      # Without these it silently fails
      pkgs.xlibs.libXinerama
      pkgs.xlibs.libXdamage
      pkgs.xlibs.libXcursor
      pkgs.xlibs.libXrender
      pkgs.xlibs.libXScrnSaver
      pkgs.xlibs.libXi
      pkgs.xlibs.libSM
      pkgs.xlibs.libICE
      pkgs.gnome2.GConf
      pkgs.freetype
      pkgs.openalSoft
      pkgs.curl
      pkgs.nspr
      pkgs.nss
      pkgs.fontconfig
      pkgs.cairo
      pkgs.pango
      pkgs.alsaLib
      pkgs.expat
      pkgs.dbus
      pkgs.cups
      pkgs.libcap
      pkgs.SDL2
      pkgs.libusb1
      pkgs.dbus_glib
      pkgs.libav
      pkgs.atk
      # Only libraries are needed from those two
      pkgs.udev182
      pkgs.networkmanager098

      # Verified games requirements
      pkgs.xlibs.libXmu
      pkgs.xlibs.libxcb
      pkgs.xlibs.libpciaccess
      pkgs.mesa_glu
      pkgs.libuuid
      pkgs.libogg
      pkgs.libvorbis
      pkgs.SDL
      pkgs.SDL2_image
      pkgs.glew110
      pkgs.openssl
      pkgs.libidn

      # Other things from runtime
      pkgs.xlibs.libXinerama
      pkgs.flac
      pkgs.freeglut
      pkgs.libjpeg
      pkgs.libpng12
      pkgs.libsamplerate
      pkgs.libmikmod
      pkgs.libtheora
      pkgs.pixman
      pkgs.speex
      pkgs.SDL_image
      pkgs.SDL_ttf
      pkgs.SDL_mixer
      pkgs.SDL2_net
      pkgs.SDL2_ttf
      pkgs.SDL2_mixer
      pkgs.gstreamer
      pkgs.gst_plugins_base

      # Not formally in runtime but needed by some games
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-ugly
    ];

  extraBuildCommandsMulti = ''
    cd usr/lib
    ln -sf ../lib64/steam steam

    # FIXME: maybe we should replace this with proper libcurl-gnutls
    ln -s libcurl.so.4 libcurl-gnutls.so.4
  '';

  profile = ''
    ${if config.steam.enableRuntime or false then "" else "export STEAM_RUNTIME=0"}
  '';

  runScript = "steam";
}
