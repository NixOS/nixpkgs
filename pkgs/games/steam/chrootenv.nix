{ lib, buildFHSUserEnv, steam
, withJava ? false
, withPrimus ? false
, nativeOnly ? false
, runtimeOnly ? false
, newStdcpp ? false
}:

buildFHSUserEnv {
  name = "steam";

  targetPkgs = pkgs: with pkgs; [
      steamPackages.steam
      steamPackages.steam-fonts
      # License agreement
      gnome3.zenity
      # Errors in output without those
      pciutils
      python2
      # Games' dependencies
      xlibs.xrandr
      which
      # Needed by gdialog, including in the steam-runtime
      perl
    ]
    ++ lib.optional withJava jdk
    ++ lib.optional withPrimus (primus.override {
      stdenv = useOldCXXAbi stdenv;
      stdenv_i686 = useOldCXXAbi pkgsi686Linux.stdenv;
    })
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

      (steamPackages.steam-runtime-wrapped.override {
        inherit nativeOnly runtimeOnly newStdcpp;
      })
    ];

  extraBuildCommands = ''
    mkdir -p steamrt

    ln -s ../lib64/steam-runtime steamrt/amd64
    ln -s ../lib32/steam-runtime steamrt/i386
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -s ${steam}/share/icons $out/share
    ln -s ${steam}/share/pixmaps $out/share
    sed "s,/usr/bin/steam,$out/bin/steam,g" ${steam}/share/applications/steam.desktop > $out/share/applications/steam.desktop
  '';

  profile = ''
    export STEAM_RUNTIME=/steamrt
  '';

  runScript = "steam";
}
