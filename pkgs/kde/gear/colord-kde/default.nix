{
  mkKdeDerivation,
  pkg-config,
  lcms2,
  xorg,
}:
mkKdeDerivation {
  pname = "colord-kde";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [lcms2 xorg.libXrandr];
  meta.mainProgram = "colord-kde-icc-importer";
}
