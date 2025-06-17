{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "layer-shell-qt";

  extraNativeBuildInputs = [
    pkg-config
    qtwayland
  ];

  extraBuildInputs = [ qtwayland ];
}
