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
, enableQt ? false
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-skk";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-vg79zJ/ZoUjCKU11krDUjO0rAyZxDMsBnHqJ/I6NTTA=";
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
    "-DSKK_DEFAULT_PATH=${skk-dicts}/share/SKK-JISYO.L"
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
