{
  mkKdeDerivation,
  qttools,
  qtsvg,
  pkg-config,
  eigen,
  shared-mime-info,
  gsl,
  libqalculate,
}:
mkKdeDerivation {
  pname = "step";

  extraNativeBuildInputs = [qttools qtsvg pkg-config shared-mime-info];
  extraBuildInputs = [eigen gsl libqalculate];
  meta.mainProgram = "step";
}
