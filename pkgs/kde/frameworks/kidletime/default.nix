{
  mkKdeDerivation,
  lib,
  qtwayland,
  pkg-config,
  libxscrnsaver,
}:
mkKdeDerivation {
  pname = "kidletime";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland
    libxscrnsaver
  ];

  meta.badPlatforms = lib.platforms.darwin;
}
