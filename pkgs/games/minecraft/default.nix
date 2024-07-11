{ lib
, stdenv
, buildFHSEnv
, fetchurl
, fetchzip
, nixosTests
, copyDesktopItems
, makeDesktopItem
, xorg
, zlib
, nss
, nspr
, fontconfig
, pango
, cairo
, expat
, alsa-lib
, cups
, dbus
, atk
, gtk3-x11
, gtk2-x11
, gdk-pixbuf
, glib
, curl
, freetype
, libpulseaudio
, libuuid
, systemd
, libdrm
, libxkbcommon
, libGL
, xdg-utils
, libsecret
, orca
, mesa
, flite
}:
let
  pname = "minecraft-launcher";
  version = "1.0";

  minecraft-launcher = stdenv.mkDerivation {
    inherit pname version;

    src = fetchzip {
      url = "https://web.archive.org/web/20240711212151/https://launcher.mojang.com/download/Minecraft.tar.gz";
      sha256 = "sha256-aCHY3yE/o8m7WbA+rY4mRd2FFJiqnBE5EtadwHLfbn0=";
    };

    icon = fetchurl {
      url = "https://web.archive.org/web/20240901161401/https://launcher.mojang.com/download/minecraft-launcher.svg";
      sha256 = "0w8z21ml79kblv20wh5lz037g130pxkgs8ll9s3bi94zn2pbrhim";
    };

    nativeBuildInputs = [ copyDesktopItems ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mv minecraft-launcher $out/bin

      install -D $icon $out/share/icons/hicolor/symbolic/apps/minecraft-launcher.svg

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "minecraft-launcher";
        exec = "minecraft-launcher";
        icon = "minecraft-launcher";
        comment = "Official launcher for Minecraft, a sandbox-building game";
        desktopName = "Minecraft Launcher";
        categories = [ "Game" ];
      })
    ];
  };
in
buildFHSEnv {
  name = pname;
  inherit version;

  runScript = "minecraft-launcher";

  targetPkgs = _: [
    minecraft-launcher
    curl
    libpulseaudio
    systemd
    alsa-lib # needed for narrator
    flite # needed for narrator
    xorg.libXxf86vm # needed only for versions <1.13
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    gtk3-x11
    gtk2-x11
    nspr
    nss
    stdenv.cc.cc
    zlib
    libuuid
    libdrm
    libxkbcommon
    libGL
    xdg-utils
    libsecret
    orca
    mesa
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
  ];

  passthru = {
    tests = { inherit (nixosTests) minecraft; };
  };

  meta = with lib; {
    description = "Official launcher for Minecraft, a sandbox-building game";
    homepage = "https://minecraft.net";
    maintainers = with maintainers; [ cpages ryantm ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
