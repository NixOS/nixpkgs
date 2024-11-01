{ lib
, stdenv
, copyDesktopItems
, makeDesktopItem
, fetchFromGitHub
, fetchpatch
, cmake
, sfml
, qtbase
, qttools
, qtsass
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "eontimer";
  version = "unstable-2020-05-22";

  src = fetchFromGitHub {
    owner = "DasAmpharos";
    repo = "EonTimer";
    rev = "d53e42a508de4003b719791ce36e37a8f49dbfc9";
    sha256 = "jelFKEaifMOtKWJIkJvDMoP+dsQOfNPkx9YjyK4HVj4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/DasAmpharos/EonTimer/pull/95/commits/70685414d8f052394badd0f45daff4083018c788.patch";
      sha256 = "AcExUornaHtvEgg3TzAkf9TCXAJ0kdgcV++yUTxX3NI=";
    })
    ./set-desktop-file-name.patch
  ];

  preConfigure = ''
    qtsass -o resources/styles resources/styles
  '';

  installPhase = ''
    runHook preInstall
    install -D EonTimer $out/bin/EonTimer
    install -Dm 644 $src/docs/icon.svg $out/share/pixmaps/EonTimer.svg
    runHook postInstall
  '';

  nativeBuildInputs = [ cmake qtsass wrapQtAppsHook copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "eontimer";
      exec = "EonTimer";
      icon = "EonTimer";
      comment = "Timer designed for Pokémon RNG";
      desktopName = "EonTimer";
      categories = [ "Utility" ];
    })
  ];

  buildInputs = [ qtbase qttools sfml ];

  meta = with lib; {
    homepage = "https://github.com/DasAmpharos/EonTimer";
    description = "Timer designed for Pokémon RNG";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ leo60228 ];
  };
}
