{ lib, buildFHSUserEnv
, withJava   ? false
, withPrimus ? false
}:

buildFHSUserEnv {
  name = "steam";

  targetPkgs = pkgs: with pkgs; [
      steamPackages.steam
      # Errors in output without those
      pciutils
      python2
      # Games' dependencies
      xlibs.xrandr
      which
      # Needed by gdialog, including in the steam-runtime
      perl
      # Problems with text visibility in some games
      corefonts
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

      # Not formally in runtime but needed by some games
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
      libdrm

      steamPackages.steam-runtime-wrapped
    ];

  extraBuildCommands = ''
    [ -d lib64 ] && mv lib64/steam lib

    mkdir -p steamrt

    ln -s ../lib64/steam-runtime steamrt/amd64
    ln -s ../lib/steam-runtime steamrt/i386
  '';

  profile = ''
    export STEAM_RUNTIME=/steamrt
  '';

  runScript = "steam";
}
