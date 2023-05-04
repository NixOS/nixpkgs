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
, skk-dicts
, wrapQtAppsHook
, enableQt ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-skk";
  version = "5.0.15";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-y5GciWJMEFQM8SsqYANXe/SdVq6GEqsfF1yrKKhw0KA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    pkg-config
  ] ++ lib.optional enableQt wrapQtAppsHook;

  buildInputs = [
    fcitx5
    libskk
  ] ++ lib.optionals enableQt [
    fcitx5-qt
    qtbase
  ];

  cmakeFlags = [
    "-DENABLE_QT=${toString enableQt}"
    "-DSKK_DEFAULT_PATH=${skk-dicts}/share/SKK-JISYO.L"
  ];

  meta = with lib; {
    description = "Input method engine for Fcitx5, which uses libskk as its backend";
    homepage = "https://github.com/fcitx/fcitx5-skk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ milran ];
    platforms = platforms.linux;
  };
}
