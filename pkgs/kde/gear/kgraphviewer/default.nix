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

  extraNativeBuildInputs = [
    pkg-config
    qt5compat
  ];

  extraBuildInputs = [
    qt5compat
    qtsvg
    boost
    graphviz
  ];
}
