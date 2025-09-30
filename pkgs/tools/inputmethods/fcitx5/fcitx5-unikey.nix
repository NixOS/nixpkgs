{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fcitx5,
  fcitx5-qt,
  gettext,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-unikey";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    hash = "sha256-ve+vu/bK3GYgjn9KxuOsFZFi9eymi1TFlzUHu4fJAkk=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext # msgfmt
  ];

  buildInputs = [
    qtbase
    fcitx5
    fcitx5-qt
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.linux;
  };
}
