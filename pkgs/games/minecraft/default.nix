{ lib, stdenv
, fetchurl
, nixosTests
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, wrapGAppsHook3
, gobject-introspection
, jre # old or modded versions of the game may require Java 8 (https://aur.archlinux.org/packages/minecraft-launcher/#pinned-674960)
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
, flite ? null
, libXxf86vm ? null
}:
let
  desktopItem = makeDesktopItem {
    name = "minecraft-launcher";
    exec = "minecraft-launcher";
    icon = "minecraft-launcher";
    comment = "Official launcher for Minecraft, a sandbox-building game";
    desktopName = "Minecraft Launcher";
    categories = [ "Game" ];
  };

  envLibPath = lib.makeLibraryPath [
    curl
    libpulseaudio
    systemd
    alsa-lib # needed for narrator
    flite # needed for narrator
    libXxf86vm # needed only for versions <1.13
  ];

  libPath = lib.makeLibraryPath ([
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
  ] ++
  (with xorg; [
    libX11
    libxcb
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libXScrnSaver
  ]));
in
stdenv.mkDerivation rec {
  pname = "minecraft-launcher";

  version = "2.2.1441";

  src = fetchurl {
    url = "https://launcher.mojang.com/download/linux/x86_64/minecraft-launcher_${version}.tar.gz";
    sha256 = "03q579hvxnsh7d00j6lmfh53rixdpf33xb5zlz7659pvb9j5w0cm";
  };

  icon = fetchurl {
    url = "https://launcher.mojang.com/download/minecraft-launcher.svg";
    sha256 = "0w8z21ml79kblv20wh5lz037g130pxkgs8ll9s3bi94zn2pbrhim";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook3 copyDesktopItems gobject-introspection ];

  sourceRoot = ".";

  dontWrapGApps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    mv minecraft-launcher $out/opt

    install -D $icon $out/share/icons/hicolor/symbolic/apps/minecraft-launcher.svg

    runHook postInstall
  '';

  preFixup = ''
    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --set-rpath '$ORIGIN/'":${libPath}" \
      $out/opt/minecraft-launcher/minecraft-launcher
    patchelf \
      --set-rpath '$ORIGIN/'":${libPath}" \
      $out/opt/minecraft-launcher/libcef.so
    patchelf \
      --set-rpath '$ORIGIN/'":${libPath}" \
      $out/opt/minecraft-launcher/liblauncher.so
  '';

  postFixup = ''
    # Do not create `GPUCache` in current directory
    makeWrapper $out/opt/minecraft-launcher/minecraft-launcher $out/bin/minecraft-launcher \
      --prefix LD_LIBRARY_PATH : ${envLibPath} \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --set JAVA_HOME ${lib.getBin jre} \
      --chdir /tmp \
      "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Official launcher for Minecraft, a sandbox-building game";
    homepage = "https://minecraft.net";
    maintainers = with maintainers; [ ryantm ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    # "minecraft-launcher will fail on NixOS for minecraft versions >1.19
    # try prismlauncher or atlauncher instead"
    broken = true;
  };

  passthru = {
    tests = { inherit (nixosTests) minecraft; };
    updateScript = ./update.sh;
  };
}
