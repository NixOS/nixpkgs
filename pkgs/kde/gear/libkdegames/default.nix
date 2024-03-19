{
  mkKdeDerivation,
  _7zz,
  svgcleaner,
  qtdeclarative,
  qtsvg,
  openal,
  libsndfile,
}:
mkKdeDerivation {
  pname = "libkdegames";

  extraNativeBuildInputs = [_7zz svgcleaner];
  extraBuildInputs = [openal libsndfile qtdeclarative qtsvg];
}
