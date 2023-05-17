{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, glibc
, zlib
, libX11
, libICE
, libSM
, fontconfig
, gtk3
, copyDesktopItems
, graphicsmagick
, wrapGAppsHook
, makeDesktopItem
}:

buildDotnetModule rec {
  pname = "scarab";
  version = "1.31.0.0";

  src = fetchFromGitHub {
    owner = "fifty-six";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oReU0kL0wPR6oqhq/uzO7nD1qo74h36w/gyvgffwzns=";
  };

  nugetDeps = ./deps.nix;
  projectFile = "Scarab.sln";
  executables = [ "Scarab" ];

  runtimeDeps = [
    glibc
    zlib
    libX11
    libICE
    libSM
    fontconfig
    gtk3
  ];

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    copyDesktopItems
    graphicsmagick
    wrapGAppsHook
  ];

  postFixup = ''
    # Icon for the desktop file
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    gm convert $src/Scarab/Assets/omegamaggotprime.ico $out/share/icons/hicolor/256x256/apps/scarab.png
  '';

  desktopItems = [(makeDesktopItem {
    desktopName = "Scarab";
    name = "scarab";
    exec = "Scarab";
    icon = "scarab";
    comment = meta.description;
    type = "Application";
    categories = [ "Game" ];
  })];

  meta = with lib; {
    description = "Hollow Knight mod installer and manager";
    homepage = "https://github.com/fifty-six/Scarab";
    downloadPage = "https://github.com/fifty-six/Scarab/releases";
    changelog = "https://github.com/fifty-six/Scarab/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ huantian ];
    mainProgram = "Scarab";
    platforms = platforms.linux;
  };
}
