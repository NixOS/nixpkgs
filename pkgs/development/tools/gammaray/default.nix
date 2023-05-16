{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
<<<<<<< HEAD
, qtbase
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wayland
, elfutils
, libbfd
}:

stdenv.mkDerivation rec {
  pname = "gammaray";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-C8bej0q4p8F27hiJUye9G+sZbkAYaV8hW1GKWZyHAis=";
=======
    hash = "sha256-ZFLHBPIjkbHlsatwuXdut1C5MpdkVUb9T7TTNhtP764=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
    qtbase
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wayland
    elfutils
    libbfd
  ];

  meta = with lib; {
    description = "A software introspection tool for Qt applications developed by KDAB";
    homepage = "https://github.com/KDAB/GammaRay";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
<<<<<<< HEAD
    mainProgram = "gammaray";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

