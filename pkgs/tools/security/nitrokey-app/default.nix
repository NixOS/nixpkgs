{ lib
, stdenv
, cmake
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, wrapQtAppsHook
, libnitrokey
, cppcodec
, qttools
=======
, qttranslations
, wrapQtAppsHook
, libnitrokey
, cppcodec
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "nitrokey-app";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "v${version}";
    hash = "sha256-c6EC5uuMna07xVHDRFq0UDwuSeopZTmZGZ9ZD5zaq8Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
<<<<<<< HEAD
    qttools
=======
    qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [
    "-DADD_GIT_INFO=OFF"
    "-DBASH_COMPLETION_PATH=share/bash-completion/completions"
  ];

  buildInputs = [
    libnitrokey
    cppcodec
  ];

  meta = with lib; {
    description      = "Provides extra functionality for the Nitrokey Pro and Storage";
    longDescription  = ''
       The nitrokey-app provides a QT system tray widget with which you can
       access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
       See https://www.nitrokey.com/ for more information.
    '';
    homepage         = "https://github.com/Nitrokey/nitrokey-app";
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ kaiha panicgh ];
  };
}
