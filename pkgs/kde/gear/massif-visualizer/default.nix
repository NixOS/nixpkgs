{
  mkKdeDerivation,
  shared-mime-info,
  qt5compat,
  qtsvg,
}:
mkKdeDerivation {
  pname = "massif-visualizer";

  extraNativeBuildInputs = [
    shared-mime-info
    qt5compat
  ];

  extraBuildInputs = [ qtsvg ];
}
