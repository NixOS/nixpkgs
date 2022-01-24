{ lib, stdenv, fetchFromGitHub, cmake, extra-cmake-modules, fcitx5, fcitx5-qt
, ninja, gettext, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-unikey";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    sha256 = "BFIqMmjIC29Z4rATZEf+qQWrULU9Wkuk6WOUXDEPO10=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];

  buildInputs = [ fcitx5 fcitx5-qt ninja gettext ];

  meta = with lib; {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.linux;
  };
}
