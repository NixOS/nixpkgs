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
  version = "5.1.7";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.zst";
    hash = "sha256-lY5GFbeIee7u1NsLbkYt6BvST9lidvZLpaylL0wE2+0=";
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

  meta = with lib; {
    description = "Anthy Wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-anthy";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elnudev ];
    platforms = platforms.linux;
  };
}
