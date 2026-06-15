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

  outputs = [
    "out"
    "doc"
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qt5compat
    qtsvg
    boost
    graphviz
  ];
}
