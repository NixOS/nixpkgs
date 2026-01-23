{
  mkKdeDerivation,
  pkg-config,
  lcms2,
  libxrandr,
}:
mkKdeDerivation {
  pname = "colord-kde";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    lcms2
    libxrandr
  ];
  meta.mainProgram = "colord-kde-icc-importer";
}
