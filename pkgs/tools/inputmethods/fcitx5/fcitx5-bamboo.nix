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
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-bamboo";
    rev = finalAttrs.version;
    hash = "sha256-xZzIpJQMyifu4GqAwiXgwGP4wO2j4Au5qEr49Ko2FjA=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    go
  ];

  buildInputs = [
    fcitx5
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  meta = {
    description = "Vietnamese input method engine support for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-bamboo";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
