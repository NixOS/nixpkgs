{
  mkKdeDerivation,
  pkg-config,
  qt5compat,
  qtsvg,
  boost,
  graphviz,
}:
mkKdeDerivation {
  pname = "kgraphviewer";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qt5compat qtsvg boost graphviz ];
}
