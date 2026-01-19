{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  fcitx5,
  anthy,
  gettext,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-anthy";
  version = "5.1.9";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.zst";
    hash = "sha256-XDsKmhc5h3YAEfQOWtK46tZ+70DS1Cv3RP5kkixSQN8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext # msgfmt
    pkg-config
    zstd
  ];
  buildInputs = [
    fcitx5
    anthy
  ];

  meta = {
    description = "Anthy Wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-anthy";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ elnudev ];
    platforms = lib.platforms.linux;
  };
}
