{ stdenv, lib, buildFHSUserEnv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, fetchurl, wrapGAppsHook
, gnome2, xorg
, libSM, libXxf86vm, libX11, glib, pango, cairo, gtk2-x11, zlib, openssl
, libpulseaudio
, SDL2, xorg_sys_opengl, libGL
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
      wrapGAppsHook
      dpkg
    ];

    buildInputs = [
      glibc
      gcc-unwrapped
      libSM
      libXxf86vm
      libX11
      glib
      pango
      cairo
      gtk2-x11
      zlib
      openssl
    ];

    runtimeDependencies = [
      libpulseaudio
      libGL
      SDL2
      xorg_sys_opengl
      openssl
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
      dpkg glibc gcc-unwrapped
      libSM libXxf86vm libX11 glib pango cairo gtk2-x11 zlib openssl
      libpulseaudio
      xorg.libX11
      SDL2 xorg_sys_opengl libGL
    ];
    multiPkgs = pkgs: [ libGL ];
    runScript = "runescape-launcher";

    meta = with lib; {
      description = "RuneScape Game Client (NXT) - Launcher for RuneScape 3";
      homepage = "https://www.runescape.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [ grburst ];
      platforms = [ "x86_64-linux" ];
    };
  }
