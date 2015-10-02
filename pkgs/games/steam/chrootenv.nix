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
      pkgs.xorg.xrandr
      pkgs.which
      pkgs.libcxxabi
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
      pkgs.xorg.libICE
      pkgs.xorg.libSM
      pkgs.xorg.libX11
      pkgs.xorg.libXau
      pkgs.xorg.libxcb
      pkgs.xorg.libXcursor
      pkgs.xorg.libXdamage
      pkgs.xorg.libXdmcp
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXi
      pkgs.xorg.libXinerama
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXScrnSaver
      pkgs.xorg.libXtst
      pkgs.xorg.libXxf86vm
      
      pkgs.libcxxabi

      pkgs.ffmpeg
      pkgs.libpng12
      pkgs.mesa
      pkgs.SDL
      pkgs.SDL2
      pkgs.libdrm

      pkgs.libgcrypt
      pkgs.zlib

      pkgs.alsaLib
      pkgs.libvorbis
      pkgs.openal
      pkgs.libpulseaudio

      pkgs.gst_all_1.gst-plugins-ugly # "Audiosurf 2" needs this
    ];

  extraBuildCommandsMulti = ''
    cd usr/lib
    ln -sf ../lib64/steam steam
  '';

  profile = ''
    # Ugly workaround for https://github.com/ValveSoftware/steam-for-linux/issues/3504
    export LD_PRELOAD=/lib32/libpulse.so:/lib64/libpulse.so:/lib32/libasound.so:/lib64/libasound.so:$LD_PRELOAD
    # Another one for https://github.com/ValveSoftware/steam-for-linux/issues/3801
    export LD_PRELOAD=/lib32/libstdc++.so:/lib64/libstdc++.so:$LD_PRELOAD
    # An ugly fix to get Sid Meier's Civilization V to launch.
    export LD_PRELOAD=/lib32/libc++abi.so:/lib64/libc++abi.so:$LD_PRELOAD
  '';

  runScript = "steam";
}
