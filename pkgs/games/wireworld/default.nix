{ lib
, stdenv
, fetchFromGitLab
, zip
, love
, makeWrapper
, makeDesktopItem
, copyDesktopItems
<<<<<<< HEAD
, strip-nondeterminism
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "wireworld";
  version = "unstable-2023-05-09";

  src = fetchFromGitLab {
    owner = "blinry";
    repo = pname;
    rev = "03b82bf5d604d6d4ad3c07b224583de6c396fd17";
    hash = "sha256-8BshnGLuA8lmG9g7FU349DWKP/fZvlvjrQBau/LSJ4E=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    strip-nondeterminism
    zip
  ];
=======
  nativeBuildInputs = [ makeWrapper copyDesktopItems zip ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  desktopItems = [
    (makeDesktopItem {
      name = "Wireworld";
      exec = pname;
      comment = "";
      desktopName = "Wireworld";
      genericName = "Wireworld";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    zip -9 -r Wireworld.love ./*
<<<<<<< HEAD
    strip-nondeterminism --type zip Wireworld.love
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    install -Dm444 -t $out/share/games/lovegames/ Wireworld.love
    makeWrapper ${love}/bin/love $out/bin/Wireworld \
      --add-flags $out/share/games/lovegames/Wireworld.love
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fascinating electronics logic puzzles, game where you'll learn how to build clocks, diodes, and logic gates";
    license = with licenses; [
      mit
      ofl
      blueOak100
      cc-by-sa-30
      cc-by-sa-40
    ];
    downloadPage = "https://ldjam.com/events/ludum-dare/53/wireworld";
    maintainers = with lib.maintainers; [ janik ];
  };

}
