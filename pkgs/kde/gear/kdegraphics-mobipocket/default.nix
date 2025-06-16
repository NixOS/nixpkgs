{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kdegraphics-mobipocket";

  # FIXME: this should not be necessary, but cmake cross is weird
  extraNativeBuildInputs = [ qt5compat ];

  extraBuildInputs = [ qt5compat ];
}
