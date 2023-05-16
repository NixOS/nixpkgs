{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, fcitx5-qt
, gettext
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-unikey";
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-X00/jGtbApWtS9+S6lTXJ0+BK7SUsLA1sKxq0vW1VNE=";
=======
    sha256 = "sha256-UpCXcgVUGe5/yunLqRNx2H2aLOnD1wJNA8y3q8R4+sY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];

  buildInputs = [ fcitx5 fcitx5-qt gettext ];

  meta = with lib; {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.linux;
  };
}
