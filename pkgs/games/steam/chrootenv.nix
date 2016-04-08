{ stdenv, lib, writeScript, buildFHSUserEnv, steam
, steam-runtime, steam-runtime-i686 ? null
, withJava ? false
, withPrimus ? false
, nativeOnly ? false
, runtimeOnly ? false
, newStdcpp ? false
}:

let
  self = {
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
      # Open URLs
      xdg_utils
    ] ++ lib.optional withJava jdk
      ++ lib.optional withPrimus (primus.override {
           stdenv = overrideInStdenv stdenv [ useOldCXXAbi ];
           stdenv_i686 = overrideInStdenv pkgsi686Linux.stdenv [ useOldCXXAbi ];
         });

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
      ln -s ../lib/steam-runtime steamrt/${steam-runtime.arch}
      ${lib.optionalString (steam-runtime-i686 != null) ''
        ln -s ../lib32/steam-runtime steamrt/${steam-runtime-i686.arch}
      ''}
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

    passthru.run = buildFHSUserEnv (self // {
      name = "steam-run";

      runScript =
        let ldPath = map (x: "/steamrt/${steam-runtime.arch}/" + x) steam-runtime.libs
                   ++ lib.optionals (steam-runtime-i686 != null) (map (x: "/steamrt/${steam-runtime-i686.arch}/" + x) steam-runtime-i686.libs);
        in writeScript "steam-run" ''
          #!${stdenv.shell}
          run="$1"
          if [ "$run" = "" ]; then
            echo "Usage: steam-run command-to-run args..." >&2
            exit 1
          fi
          shift
          export LD_LIBRARY_PATH=${lib.concatStringsSep ":" ldPath}:$LD_LIBRARY_PATH
          exec "$run" "$@"
        '';

      passthru = {};
    });
  };

in buildFHSUserEnv self
