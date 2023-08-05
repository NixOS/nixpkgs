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
, libglvnd
, pipewire
, libpulseaudio
, experimental ? false
, dotnet-runtime_7
}:

stdenv.mkDerivation rec {
  pname = "vintagestory";
  version = if experimental then "1.18.8-rc.1" else "1.18.7";

  src =
    if experimental
    then
      (fetchurl {
        url = "https://cdn.vintagestory.at/gamefiles/unstable/vs_client_linux-x64_${version}.tar.gz";
        hash = "sha256-FxyAJTiLENTp5QxPKRgsiOhkMXz88CTn3QRvIHtOH+A=";
      })
    else
      (fetchurl {
        url = "https://cdn.vintagestory.at/gamefiles/stable/vs_archive_${version}.tar.gz";
        hash = "sha256-geJoNxBxODXQeTExLdTOaH84asjo2yg2xFm8Pj0IMc0=";
      });


  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  buildInputs =
    if experimental then [
      dotnet-runtime_7
    ] else [
      mono
    ];

  runtimeLibs = lib.makeLibraryPath ([
    gtk2
    sqlite
    openal
    cairo
    libGLU
    SDL2
    freealut
    libglvnd
    pipewire
    libpulseaudio
  ] ++ (with xorg; [
    libX11
    libXi
  ]));

  desktopItems = makeDesktopItem {
    name = "vintagestory";
    desktopName = if experimental then "Vintage Story Experimental .net 7" else "Vintage Story";
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

  preFixup = (if experimental then ''
    makeWrapper ${dotnet-runtime_7}/bin/dotnet $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/Vintagestory.dll
    makeWrapper ${dotnet-runtime_7}/bin/dotnet $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.dll
  '' else ''
    makeWrapper ${mono}/bin/mono $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/Vintagestory.exe
    makeWrapper ${mono}/bin/mono $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags $out/share/vintagestory/VintagestoryServer.exe
  '') + ''
    find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      local filename="$(basename -- "$file")"
      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
    done
  '';

  meta = with lib; {
    description = "An in-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = licenses.unfree;
    maintainers = with maintainers; [ artturin gigglesquid ];
  };
}
