{ lib
, qt5
, qtbase
<<<<<<< HEAD
=======
, qtsvg
, qtx11extras
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qttools
, qtwebsockets
, qtmultimedia
, fetchFromGitHub
}:

<<<<<<< HEAD
qt5.mkDerivation {
=======
qt5.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "r3ctl";
  version = "a82cb5b3123224e706835407f21acea9dc7ab0f0";

  src = fetchFromGitHub {
    owner = "0xfeedc0de64";
    repo = "r3ctl";
    rev = "a82cb5b3123224e706835407f21acea9dc7ab0f0";
    sha256 = "5/L8jvEDJGJzsuAxPrctSDS3d8lbFX/+f52OVyGQ/RY=";
  };

  buildPhase = ''
    qmake .
    make
  '';

  postInstall = ''
    mv bin $out
  '';

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
    qtmultimedia
    qtwebsockets
  ];

  meta = with lib; {
    description = "A cmdline tool to control the r3 hackerspace lights";
    homepage = "https://github.com/0xfeedc0de64/r3ctl";
    maintainers = with maintainers; [ mkg20001 ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
