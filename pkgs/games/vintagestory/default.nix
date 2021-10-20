{ lib
, stdenv
, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, mono
, xorg
, gtk2
, sqlite
, openal
, cairo
, libGLU
, SDL2
, freealut
}:

stdenv.mkDerivation rec {
  pname = "vintagestory";
  version = "1.15.5";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_archive_${version}.tar.gz";
    sha256 = "sha256-38vLkH8B1yYC1I8P8uCsbC8CK8Btpfm9tNxgiuswsa8=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  buildInputs = [ mono ];

  runtimeLibs = lib.makeLibraryPath ([
    gtk2
    sqlite
    openal
    cairo
    libGLU
    SDL2
    freealut
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
    type = "Application";
    categories = "Game;";
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
    makeWrapper ${mono}/bin/mono $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/Vintagestory.exe
    makeWrapper ${mono}/bin/mono $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.exe

    find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      local filename="$(basename -- "$file")"
      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
    done
  '';

  meta = with lib; {
    description = "An in-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = licenses.unfree;
    maintainers = with maintainers; [ artturin ];
  };
}
