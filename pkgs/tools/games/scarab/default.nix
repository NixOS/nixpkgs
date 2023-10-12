{ lib
, buildDotnetModule
, fetchFromGitHub
, glibc
, zlib
, libX11
, libICE
, libSM
, fontconfig
, gtk3
, copyDesktopItems
, icoutils
, wrapGAppsHook
, makeDesktopItem
}:

buildDotnetModule rec {
  pname = "scarab";
  version = "2.1.0.0";

  src = fetchFromGitHub {
    owner = "fifty-six";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TbsCj30ZlZmm+i/k31eo9X+XE9Zu13uL9QZOGaRm9zs=";
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
    icoutils
    wrapGAppsHook
  ];

  postFixup = ''
    # Icons for the desktop file
    icotool -x $src/Scarab/Assets/omegamaggotprime.ico

    sizes=(256 128 64 48 32 16)
    for i in ''${!sizes[@]}; do
      size=''${sizes[$i]}x''${sizes[$i]}
      install -D omegamaggotprime_''$((i+1))_''${size}x32.png $out/share/icons/hicolor/$size/apps/scarab.png
    done
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

  passthru.updateScript = ./update.sh;

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
