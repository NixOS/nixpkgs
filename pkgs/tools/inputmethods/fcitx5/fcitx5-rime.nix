{ lib, stdenv
, fetchurl
, fetchFromGitHub
, pkgconfig
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, librime
, brise
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-rime";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-rime";
    rev = version;
    sha256 = "cVCTsD1Iw6OtyYFpxff3ix2CubRTnDaBevAYA4I9Ai8=";
  };

  cmakeFlags = [
    "-DRIME_DATA_DIR=${brise}/share/rime-data"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkgconfig
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
