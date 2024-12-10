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
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    hash = "sha256-BwKlhb3nIzBgD3XSuDOH6f2sFbtx8cc4R4qC5ZQrZus=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    fcitx5
    fcitx5-qt
    gettext
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
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
