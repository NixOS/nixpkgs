{ lib, buildFHSUserEnv, config }:

buildFHSUserEnv {
  name = "steam";

  targetPkgs = pkgs:
    [ pkgs.steam-original
      pkgs.corefonts
      pkgs.curl
      pkgs.dbus
      pkgs.dpkg
      pkgs.mono
      pkgs.python
      pkgs.gnome2.zenity
      pkgs.xdg_utils
    ]
    ++ lib.optional (config.steam.java or false) pkgs.jdk
    ++ lib.optional (config.steam.primus or false) pkgs.primus
    ;

  multiPkgs = pkgs:
    [ pkgs.cairo
      pkgs.glib
      pkgs.gtk
      pkgs.gdk_pixbuf
      pkgs.pango

      pkgs.freetype
      pkgs.xlibs.libICE
      pkgs.xlibs.libSM
      pkgs.xlibs.libX11
      pkgs.xlibs.libXau
      pkgs.xlibs.libxcb
      pkgs.xlibs.libXcursor
      pkgs.xlibs.libXdamage
      pkgs.xlibs.libXdmcp
      pkgs.xlibs.libXext
      pkgs.xlibs.libXfixes
      pkgs.xlibs.libXi
      pkgs.xlibs.libXinerama
      pkgs.xlibs.libXrandr
      pkgs.xlibs.libXrender
      pkgs.xlibs.libXScrnSaver
      pkgs.xlibs.libXtst
      pkgs.xlibs.libXxf86vm

      pkgs.ffmpeg
      pkgs.libpng12
      pkgs.mesa
      pkgs.SDL
      pkgs.SDL2

      pkgs.libgcrypt
      pkgs.zlib

      pkgs.alsaLib
      pkgs.libvorbis
      pkgs.openal
      pkgs.pulseaudio

      pkgs.flashplayer

      pkgs.gst_all_1.gst-plugins-ugly # "Audiosurf 2" needs this
    ];

  extraBuildCommandsMulti = ''
    cd usr/lib
    ln -sf ../lib64/steam steam
  '';

  profile = ''
    # Ugly workaround for https://github.com/ValveSoftware/steam-for-linux/issues/3504
    export LD_PRELOAD=/lib32/libpulse.so:/lib64/libpulse.so:/lib32/libasound.so:/lib64/libasound.so
  '';

  runScript = "steam";
}
