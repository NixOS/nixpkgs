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
<<<<<<< HEAD
  version = "5.1.9";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.zst";
    hash = "sha256-XDsKmhc5h3YAEfQOWtK46tZ+70DS1Cv3RP5kkixSQN8=";
=======
  version = "5.1.8";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.zst";
    hash = "sha256-O/fpLWh5eE22lZEz4cyI60Xf/rTWpTCWjAib3y0Yac8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Anthy Wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-anthy";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ elnudev ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Anthy Wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-anthy";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elnudev ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
