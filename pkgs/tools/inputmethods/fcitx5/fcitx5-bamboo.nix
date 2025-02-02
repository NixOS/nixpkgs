{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, gettext
, go
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-bamboo";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-bamboo";
    rev = finalAttrs.version;
    hash = "sha256-lWWSk5HxWFJKoE3Rf2s4sYhTSLKDnmPCzYGR/NscqFY=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    go
  ];

  buildInputs = [
    fcitx5
    extra-cmake-modules
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  meta = {
    description = "Vietnamese input method engine support for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-bamboo";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.linux;
  };
})
