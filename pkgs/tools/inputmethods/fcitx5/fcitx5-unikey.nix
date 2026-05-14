{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  fcitx5,
  fcitx5-qt,
  gettext,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-unikey";
  version = "5.1.10";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    hash = "sha256-g4RK1OCRQJoLv5fLR/O2GghgBIWOKzhRbkuijIgpr7U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext # msgfmt
  ];

  buildInputs = [
    qtbase
    fcitx5
    fcitx5-qt
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ berberman ];
    platforms = lib.platforms.linux;
  };
}
