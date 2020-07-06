{ stdenv
, fetchurl
, makeDesktopItem
, makeWrapper
, wrapGAppsHook
, gobject-introspection
, jre # old or modded versions of the game may require Java 8 (https://aur.archlinux.org/packages/minecraft-launcher/#pinned-674960)
, xorg
, zlib
, nss
, nspr
, fontconfig
, gnome2
, cairo
, expat
, alsaLib
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
    categories = "Game;";
  };

  envLibPath = stdenv.lib.makeLibraryPath [
    curl
    libpulseaudio
    systemd
    alsaLib # needed for narrator
    flite # needed for narrator
    libXxf86vm # needed only for versions <1.13
  ];

  libPath = stdenv.lib.makeLibraryPath ([
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gnome2.pango
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

  version = "2.1.15166";

  src = fetchurl {
    url = "https://launcher.mojang.com/download/linux/x86_64/minecraft-launcher_${version}.tar.gz";
    sha256 = "14q41zk370zvzz2jbynhfw11r98l9x49142lqf2izfl42fhv8yhw";
  };

  icon = fetchurl {
    url = "https://launcher.mojang.com/download/minecraft-launcher.svg";
    sha256 = "0w8z21ml79kblv20wh5lz037g130pxkgs8ll9s3bi94zn2pbrhim";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ gobject-introspection ];

  sourceRoot = ".";

  dontWrapGApps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/opt
    mv minecraft-launcher $out/opt

    ${desktopItem.buildCommand}
    install -D $icon $out/share/icons/hicolor/symbolic/apps/minecraft-launcher.svg
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
      --prefix PATH : ${stdenv.lib.makeBinPath [ jre ]} \
      --set JAVA_HOME ${stdenv.lib.makeBinPath [ jre ]} \
      --run "cd /tmp" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with stdenv.lib; {
    description = "Official launcher for Minecraft, a sandbox-building game";
    homepage = "https://minecraft.net";
    maintainers = with maintainers; [ cpages ryantm infinisil ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = ./update.sh;
}
