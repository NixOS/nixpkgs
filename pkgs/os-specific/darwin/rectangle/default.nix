{ lib
, stdenvNoCC
, fetchurl
, undmg
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "rectangle";
<<<<<<< HEAD
  version = "0.70";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    hash = "sha256-YJYDzmFfLlXDupyEjoEAin5qynyLjXjuav1DSS/Q5zU=";
=======
  version = "0.68";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    hash = "sha256-N1zSMmRo6ux/b16K4Og68A5bfht2WWi7S40Yys3QkTY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Rectangle.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/rxhanson/Rectangle";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
<<<<<<< HEAD
    maintainers = with maintainers; [ Enzime Intuinewin ];
=======
    maintainers = with maintainers; [ Enzime ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
  };
}

