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
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    sha256 = "sha256-tLooADS8HojS9i178i5FJVqZtKrTXlzOBPlE9K49Tjc=";
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
