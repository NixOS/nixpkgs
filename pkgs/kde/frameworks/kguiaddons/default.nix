{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  lib,
  stdenv,
}:
mkKdeDerivation {
  pname = "kguiaddons";

  hasPythonBindings = true;

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    qtwayland
  ];

  meta.mainProgram = "kde-geo-uri-handler";
}
