{ lib, stdenv
, fetchurl
, fetchFromGitHub
, pkg-config
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, librime
, brise
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-rime";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-rime";
    rev = version;
    sha256 = "sha256-WB+bWvJxL2yywictNN8Zy0OYxiCRErQGL2dGH4zQPp8=";
  };

  cmakeFlags = [
    "-DRIME_DATA_DIR=${brise}/share/rime-data"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
  ];

  buildInputs = [
    fcitx5
    librime
  ];

  meta = with lib; {
    description = "RIME support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-rime";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
