{ buildFHSChrootEnv, config }:

buildFHSChrootEnv {
  name = "steam";

  targetPkgs = pkgs:
    [ pkgs.steam
      pkgs.corefonts
      pkgs.curl
      pkgs.dbus
      pkgs.dpkg
      pkgs.mono
      pkgs.python
      pkgs.gnome2.zenity
      pkgs.xdg_utils
    ]
    ++ (if config.steam.java or false then [ pkgs.jdk ] else [ ])
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
    ];

  extraBuildCommandsMulti = ''
    cd usr/lib
    ln -sf ../lib64/steam steam
  '';

  profile = ''
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib:/lib:/lib32:/lib64
    export PATH=$PATH:/usr/bin:/usr/sbin
  '';
}
