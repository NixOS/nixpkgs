{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fcitx5,
  gettext,
  go,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-bamboo";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-bamboo";
    rev = finalAttrs.version;
    hash = "sha256-yvyJHIXUYpOIeiSQasSRKTbN4Z0BAjohz8VlZKqMg0Q=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
