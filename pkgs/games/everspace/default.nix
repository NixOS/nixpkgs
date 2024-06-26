{
  # Packaging Dependencies
  lib, stdenv, requireFile, autoPatchelfHook, unzip, copyDesktopItems, makeDesktopItem,

  # Everspace Dependencies
  cairo, gdk-pixbuf, pango, gtk2-x11, libGL, openal,

  # Unreal Engine 4 Dependencies
  xorg
}:

# Known issues:
# - Video playback (upon starting a new game) does not work (screen is black)
stdenv.mkDerivation rec {
  pname = "everspace";
  version = "1.3.5.3655";

  src = requireFile {
    name = "everspace_1_3_5_3655_32896.sh";
    url = "https://www.gog.com/";
    sha256 = "0jlvxq14k1pxmbr08y8kar0ijlqxcnkfqlvw883j96v9zr34ynj3";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    unzip
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    pango
    gtk2-x11
    openal
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = [
    libGL

    # ue4
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXau
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXxf86vm
    xorg.libxcb
  ];

  unpackPhase = ''
    runHook preUnpack

    # The shell script contains a zip file. Unzipping it works but will result
    # in some error output and an error exit code.
    unzip "$src" || true

    runHook postUnpack
  '';

  postPatch = ''
    ## Remove Bundled Libs ##

    # vlc libs
    #
    # TODO: This is probably what breaks video playback. It would be cleaner
    #   to remove the bundled libs and replace them with system libs but there
    #   are so many. Copy-pasting the list from the vlc package is a good start
    #   but still leaves us with many unresolved dependencies.
    rm -rf ./data/noarch/game/RSG/Plugins/VlcMedia

    # openal
    rm -rf ./data/noarch/game/Engine/Binaries/ThirdParty/OpenAL
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt"
    cp -r "./data/noarch" "$out/opt/everspace"

    mkdir -p "$out/bin"
    ln -s "$out/opt/everspace/game/RSG/Binaries/Linux/RSG-Linux-Shipping" "$out/bin/everspace"

    mkdir -p "$out/share/pixmaps"
    ln -s "$out/opt/everspace/support/icon.png" "$out/share/pixmaps/everspace-gog.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "everspace-gog";
      desktopName = "EVERSPACE™";
      comment = meta.description;
      exec = "everspace";
      icon = "everspace-gog";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Action-focused single-player space shooter with roguelike elements";
    homepage = "https://classic.everspace-game.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ jtrees ];
    platforms = [ "x86_64-linux" ];
  };
}
