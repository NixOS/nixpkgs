{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  extra-cmake-modules,
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
  version = "5.1.8";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-1omxT31hKe7gQ5BARJ+0tIp4RT5eM+Tjufd6s/PxBoY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
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
    "-DSKK_DEFAULT_PATH=${skkDictionaries.l}/share/skk/SKK-JISYO.L"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses libskk as its backend";
    homepage = "https://github.com/fcitx/fcitx5-skk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wattmto ];
    platforms = platforms.linux;
  };
}
