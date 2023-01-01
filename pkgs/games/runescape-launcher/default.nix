{ stdenv
, lib
, autoPatchelfHook
, buildFHSUserEnv
, cairo
, dpkg
, fetchurl
, gcc-unwrapped
, glib
, glibc
, gnome2
, gtk2-x11
, libGL
, libpulseaudio
, libSM
, libXxf86vm
, libX11
, openssl_1_1
, pango
, SDL2
, wrapGAppsHook
, xdg-utils
, xorg
, xorg_sys_opengl
, zlib
}:
let

  runescape = stdenv.mkDerivation rec {
    pname = "runescape-launcher";
    version = "2.2.9";

    # Packages: https://content.runescape.com/downloads/ubuntu/dists/trusty/non-free/binary-amd64/Packages
    # upstream is https://content.runescape.com/downloads/ubuntu/pool/non-free/r/${pname}/${pname}_${version}_amd64.deb
    src = fetchurl {
      url = "https://archive.org/download/${pname}_${version}_amd64/${pname}_${version}_amd64.deb";
      sha256 = "1zilpxh8k8baylbl9nqq9kgjiv2xzw4lizbgcmzky5rhmych8n4g";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      wrapGAppsHook
    ];

    buildInputs = [
      cairo
      gcc-unwrapped
      glib
      glibc
      gtk2-x11
      libSM
      libXxf86vm
      libX11
      openssl_1_1
      pango
      zlib
    ];

    runtimeDependencies = [
      libGL
      libpulseaudio
      SDL2
      openssl_1_1
      xdg-utils # The launcher uses `xdg-open` to open HTTP URLs in the user's browser
      xorg_sys_opengl
      zlib
    ];

    dontUnpack = true;

    preBuild = ''
      export DH_VERBOSE=1
    '';

    envVarsWithXmodifiers = ''
      export MESA_GLSL_CACHE_DIR=~/Jagex
      export GDK_SCALE=2
      unset XMODIFIERS
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share
      dpkg -x $src $out

      patchShebangs $out/usr/bin/runescape-launcher
      substituteInPlace $out/usr/bin/runescape-launcher \
        --replace "unset XMODIFIERS" "$envVarsWithXmodifiers" \
        --replace "/usr/share/games/runescape-launcher/runescape" "$out/share/games/runescape-launcher/runescape"

      cp -r $out/usr/bin $out/
      cp -r $out/usr/share $out/

      rm -r $out/usr
    '';


    meta = with lib; {
      description = "Launcher for RuneScape 3, the current main RuneScape";
      homepage = "https://www.runescape.com/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      maintainers = with maintainers; [ grburst ];
      platforms = [ "x86_64-linux" ];
    };
  };

in

  /*
  * We can patch the runescape launcher, but it downloads a client at runtime and checks it for changes.
  * For that we need use a buildFHSUserEnv.
  * FHS simulates a classic linux shell
  */
  buildFHSUserEnv {
    name = "RuneScape";
    targetPkgs = pkgs: [
      runescape
      cairo
      dpkg
      gcc-unwrapped
      glib
      glibc
      gtk2-x11
      libGL
      libpulseaudio
      libSM
      libXxf86vm
      libX11
      openssl_1_1
      pango
      SDL2
      xdg-utils
      xorg.libX11
      xorg_sys_opengl
      zlib
    ];
    multiPkgs = pkgs: [ libGL ];
    runScript = "runescape-launcher";
    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      cp ${runescape}/share/applications/runescape-launcher.desktop "$out/share/applications"
      cp -r ${runescape}/share/icons "$out/share/icons"
      substituteInPlace "$out/share/applications/runescape-launcher.desktop" \
        --replace "/usr/bin/runescape-launcher" "RuneScape"
    '';

    meta = with lib; {
      description = "RuneScape Game Client (NXT) - Launcher for RuneScape 3";
      homepage = "https://www.runescape.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [ grburst ];
      platforms = [ "x86_64-linux" ];
    };
  }
