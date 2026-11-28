{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  qtwayland,
  pkg-config,
  lib,
  stdenv,
}:
mkKdeDerivation {
  pname = "kwindowsystem";

  extraNativeBuildInputs = [
    qttools
    pkg-config
  ];
  extraBuildInputs = [
    qtdeclarative
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    qtwayland
  ];
}
