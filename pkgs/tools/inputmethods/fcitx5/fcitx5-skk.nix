{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, fcitx5-qt
, libskk
, qtbase
, skkDictionaries
, enableQt ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-skk";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-wv5vX9eFlBUY7x4v9U+OuhKgX6V/b3iTaCvAIwJO10o=";
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
  ] ++ lib.optionals enableQt [
    fcitx5-qt
    qtbase
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" enableQt)
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
    "-DSKK_DEFAULT_PATH=${skkDictionaries.l}/share/skk/SKK-JISYO.L"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses libskk as its backend";
    homepage = "https://github.com/fcitx/fcitx5-skk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ milran ];
    platforms = platforms.linux;
  };
}
