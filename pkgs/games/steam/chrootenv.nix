{ lib, buildFHSUserEnv, steam-runtime
, withRuntime ? false
, withJava    ? false
, withPrimus  ? false
}:

buildFHSUserEnv {
  name = "steam";

  targetPkgs = pkgs: with pkgs; [
      steam-original
      # Errors in output without those
      pciutils
      python2
      # Games' dependencies
      xlibs.xrandr
      which
      # needed by gdialog, including in the steam-runtime
      perl
    ]
    ++ lib.optional withJava   jdk
    ++ lib.optional withPrimus primus
    ;

  multiPkgs = pkgs: with pkgs; [
      # These are required by steam with proper errors
      xlibs.libXcomposite
      xlibs.libXtst
      xlibs.libXrandr
      xlibs.libXext
      xlibs.libX11
      xlibs.libXfixes

      glib
      gtk2
      bzip2
      zlib
      libpulseaudio
      gdk_pixbuf

      # Not formally in runtime but needed by some games
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
    ] ++ lib.optionals withRuntime [
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
      openalSoft
      curl
      nspr
      nss
      fontconfig
      cairo
      pango
      alsaLib
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

  extraBuildCommands = ''
    [ -d lib64 ] && mv lib64/steam lib

    # FIXME: maybe we should replace this with proper libcurl-gnutls
    ln -s libcurl.so.4 lib/libcurl-gnutls.so.4
    [ -d lib64 ] && ln -s libcurl.so.4 lib64/libcurl-gnutls.so.4
  '' + lib.optionals withRuntime ''
    mkdir -p    steamrt/usr
    ln -s lib32 steamrt/lib

    if [ -d lib64 ]; then
      ln -s                    ${steam-runtime}/i386/usr/bin     steamrt/bin
    else
      ln -s                    ${steam-runtime}/amd64/usr/bin    steamrt/bin
    fi

    ln -s                      ${steam-runtime}/i386/etc         steamrt/etc
    ln -s                      ${steam-runtime}/i386/usr/include steamrt/usr/include

    cp -rsf --no-preserve mode ${steam-runtime}/i386/usr/lib     steamrt/lib32
    cp -rsf                    ${steam-runtime}/i386/lib/*       steamrt/lib32

    cp -rsf --no-preserve mode ${steam-runtime}/amd64/usr/lib    steamrt/lib64
    cp -rsf                    ${steam-runtime}/amd64/lib/*      steamrt/lib64

    libs=$(ls -dm --quoting-style=escape steamrt/lib{32,64}/{,*/})

    echo    'export STEAM_RUNTIME=0'                    >  steamrt/profile
    echo    'export PATH=$PATH:/steamrt/bin'            >> steamrt/profile
    echo -n 'export LD_LIBRARY_PATH=/'                  >> steamrt/profile
    echo -n $libs | sed 's/\/, /:\//g' | sed 's/\/$//g' >> steamrt/profile
    echo    ':$LD_LIBRARY_PATH'                         >> steamrt/profile
  '';

  profile = if withRuntime then ''
    source /steamrt/profile
  '' else ''
    # Ugly workaround for https://github.com/ValveSoftware/steam-for-linux/issues/3504
    export LD_PRELOAD=/lib32/libpulse.so:/lib64/libpulse.so:/lib32/libasound.so:/lib64/libasound.so:$LD_PRELOAD
    # Another one for https://github.com/ValveSoftware/steam-for-linux/issues/3801
    export LD_PRELOAD=/lib32/libstdc++.so:/lib64/libstdc++.so:$LD_PRELOAD
  '';

  runScript = "steam";
}
