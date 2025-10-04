{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "layer-shell-qt";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtwayland ];
}
