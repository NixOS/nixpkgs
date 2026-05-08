{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  kdePackages,
  gettext,
  fcitx5,
  fcitx5-qt,
  libskk,
  qtbase,
  skkDictionaries,
  enableQt ? false,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-skk";
  version = "5.1.10";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-4ApXom3SDwlT55lj0q3u5wBmKRGAzJCvpx1H30z3Ubo=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
    pkg-config
  ];

  buildInputs = [
    fcitx5
    libskk
  ]
  ++ lib.optionals enableQt [
    fcitx5-qt
    qtbase
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" enableQt)
    "-DSKK_PATH=${skkDictionaries.l}/share/skk"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Input method engine for Fcitx5, which uses libskk as its backend";
    homepage = "https://github.com/fcitx/fcitx5-skk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wattmto ];
    platforms = lib.platforms.linux;
  };
}
