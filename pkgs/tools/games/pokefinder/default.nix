{ lib
, stdenv
<<<<<<< HEAD
, copyDesktopItems
, makeDesktopItem
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, cmake
, qtbase
, qttools
, qtwayland
<<<<<<< HEAD
, imagemagick
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pokefinder";
<<<<<<< HEAD
  version = "4.1.2";
=======
  version = "4.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "ps8F6IcbCNybrZ02tbLNyB3YEvKlcYgCpv5Em7Riv+Q=";
    fetchSubmodules = true;
  };

  patches = [ ./set-desktop-file-name.patch ];
=======
    sha256 = "j7xgjNF8NWLFVPNItWcFM5WL8yPxgHxVX00x7lt45WI=";
    fetchSubmodules = true;
  };

  patches = [ ./cstddef.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    patchShebangs Source/Core/Resources/
  '';

<<<<<<< HEAD
  installPhase = ''
    runHook preInstall
  '' + lib.optionalString (stdenv.isDarwin) ''
    mkdir -p $out/Applications
    cp -R Source/PokeFinder.app $out/Applications
  '' + lib.optionalString (!stdenv.isDarwin) ''
    install -D Source/PokeFinder $out/bin/PokeFinder
    mkdir -p $out/share/pixmaps
    convert "$src/Source/Form/Images/pokefinder.ico[-1]" $out/share/pixmaps/pokefinder.png
  '' + ''
    runHook postInstall
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ] ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems imagemagick ];

  desktopItems = [
    (makeDesktopItem {
      name = "pokefinder";
      exec = "PokeFinder";
      icon = "pokefinder";
      comment = "Cross platform Pokémon RNG tool";
      desktopName = "PokéFinder";
      categories = [ "Utility" ];
    })
  ];
=======
  installPhase = lib.optionalString (!stdenv.isDarwin) ''
    install -D Source/Forms/PokeFinder $out/bin/PokeFinder
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -R Source/Forms/PokeFinder.app $out/Applications
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ qtbase qttools ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };
=======
  passthru.updateScript = gitUpdater { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/Admiral-Fish/PokeFinder";
    description = "Cross platform Pokémon RNG tool";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ leo60228 ];
  };
}
