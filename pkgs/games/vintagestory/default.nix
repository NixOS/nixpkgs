{ lib
, stdenv
, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
<<<<<<< HEAD
=======
, mono
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xorg
, gtk2
, sqlite
, openal
, cairo
, libGLU
, SDL2
, freealut
<<<<<<< HEAD
, libglvnd
, pipewire
, libpulseaudio
, dotnet-runtime_7
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "vintagestory";
<<<<<<< HEAD
  version = "1.18.10";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
    hash = "sha256-xkpoVFZWlqhSSDn62MbhBYU6X+l5MmPxtrewg9xKuJc=";
  };


  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  buildInputs = [ dotnet-runtime_7 ];
=======
  version = "1.17.11";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_archive_${version}.tar.gz";
    sha256 = "sha256-iIQRwnJX+7GJcOqXJutInqpSX2fKlPmwFFAq6TqNWWY=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  buildInputs = [ mono ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  runtimeLibs = lib.makeLibraryPath ([
    gtk2
    sqlite
    openal
    cairo
    libGLU
    SDL2
    freealut
<<<<<<< HEAD
    libglvnd
    pipewire
    libpulseaudio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ (with xorg; [
    libX11
    libXi
  ]));

  desktopItems = makeDesktopItem {
    name = "vintagestory";
    desktopName = "Vintage Story";
    exec = "vintagestory";
    icon = "vintagestory";
    comment = "Innovate and explore in a sandbox world";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vintagestory $out/bin $out/share/pixmaps $out/share/fonts/truetype
    cp -r * $out/share/vintagestory
    cp $out/share/vintagestory/assets/gameicon.xpm $out/share/pixmaps/vintagestory.xpm
    cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  preFixup = ''
<<<<<<< HEAD
    makeWrapper ${dotnet-runtime_7}/bin/dotnet $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/Vintagestory.dll
    makeWrapper ${dotnet-runtime_7}/bin/dotnet $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.dll
  '' + ''
=======
    makeWrapper ${mono}/bin/mono $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/Vintagestory.exe
    makeWrapper ${mono}/bin/mono $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.exe

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      local filename="$(basename -- "$file")"
      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
    done
  '';

  meta = with lib; {
    description = "An in-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = licenses.unfree;
<<<<<<< HEAD
    maintainers = with maintainers; [ artturin gigglesquid ];
=======
    maintainers = with maintainers; [ artturin ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
