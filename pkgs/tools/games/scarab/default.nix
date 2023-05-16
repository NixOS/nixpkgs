{ lib
, buildDotnetModule
, fetchFromGitHub
<<<<<<< HEAD
=======
, dotnetCorePackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, glibc
, zlib
, libX11
, libICE
, libSM
, fontconfig
, gtk3
, copyDesktopItems
<<<<<<< HEAD
, icoutils
=======
, graphicsmagick
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapGAppsHook
, makeDesktopItem
}:

buildDotnetModule rec {
  pname = "scarab";
<<<<<<< HEAD
  version = "2.1.0.0";
=======
  version = "1.31.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fifty-six";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TbsCj30ZlZmm+i/k31eo9X+XE9Zu13uL9QZOGaRm9zs=";
=======
    sha256 = "sha256-oReU0kL0wPR6oqhq/uzO7nD1qo74h36w/gyvgffwzns=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    icoutils
=======
    graphicsmagick
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapGAppsHook
  ];

  postFixup = ''
<<<<<<< HEAD
    # Icons for the desktop file
    icotool -x $src/Scarab/Assets/omegamaggotprime.ico

    sizes=(256 128 64 48 32 16)
    for i in ''${!sizes[@]}; do
      size=''${sizes[$i]}x''${sizes[$i]}
      install -D omegamaggotprime_''$((i+1))_''${size}x32.png $out/share/icons/hicolor/$size/apps/scarab.png
    done
=======
    # Icon for the desktop file
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    gm convert $src/Scarab/Assets/omegamaggotprime.ico $out/share/icons/hicolor/256x256/apps/scarab.png
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.updateScript = ./update.sh;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
