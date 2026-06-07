{
  mkKdeDerivation,
  shared-mime-info,
  qt5compat,
  qtsvg,
}:
mkKdeDerivation {
  pname = "massif-visualizer";

  extraBuildInputs = [
    qt5compat
    qtsvg
  ];
  extraNativeBuildInputs = [ shared-mime-info ];
}
