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
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    hash = "sha256-hx3GXoloO3eQP9yhLY8v1ahwvOTCe5XcBey+ZbReRjE=";
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

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
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
