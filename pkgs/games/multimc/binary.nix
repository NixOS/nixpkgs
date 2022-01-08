{ lib
, mkDerivation
, fetchzip
, fetchurl
, makeDesktopItem
, autoPatchelfHook
, makeWrapper
, jdk
, zlib
, xorg
, libpulseaudio
, qtbase
, libGL
}:

let
  gameLibraryPath = with xorg; lib.makeLibraryPath [
    libX11
    libXext
    libXcursor
    libXrandr
    libXxf86vm
    libpulseaudio
    libGL
  ];

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/MultiMC/Launcher/0.6.14/launcher/package/ubuntu/multimc/opt/multimc/icon.svg";
    sha256 = "sha256-p4q3XXU8IOmYmScj+WgUNR3OCBfX2/bOuIux1PH1G9Y=";
  };
in

mkDerivation rec {
  pname = "multimc-bin";
  version = "0.6.14";

  src = fetchzip {
    url = "https://files.multimc.org/downloads/mmc-stable-lin64.tar.gz";
    sha256 = "sha256-m4N5wLiSpNbSQ7nl3C8NSx3vO5LJtOg6WM1mqAVVaJA=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ qtbase zlib ];

  dontConfigure = true;
  dontBuild = true;

  desktopItem = makeDesktopItem {
    name = "multimc";
    exec = "multimc";
    icon = "multimc";
    desktopName = "MultiMC";
    genericName = "Minecraft Launcher";
    comment = meta.description;
    categories = "Game;";
    extraEntries = ''
      Keywords=game;Minecraft;
    '';
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/multimc $out/share/{applications,pixmaps} $out/bin
    cp -a bin/* $out/lib/multimc

    wrapProgram $out/lib/multimc/MultiMC \
      --set GAME_LIBRARY_PATH ${gameLibraryPath} \
      --set PATH ${lib.makeBinPath [ xorg.xrandr jdk ]} \
      --set LAUNCHER_DIR $XDG_DATA_HOME/.local/share/multimc \
      --add-flags '-d "''${XDG_DATA_HOME-$HOME/.local/.share}/multimc"'
    ln -s $out/lib/multimc/MultiMC $out/bin/multimc

    install -Dm644 ${desktopItem}/share/applications/multimc.desktop -t $out/share/applications
    install -Dm644 ${icon} -t $out/share/pixmaps

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://multimc.org/";
    description = "A free, open source launcher for Minecraft (Binary Package)";
    longDescription = ''
      Allows you to have multiple, separate instances of
      Minecraft (each with their own mods, texture packs, saves, etc)
      and helps you manage them and their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.asl20;
    hydraPlatforms = [];
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
