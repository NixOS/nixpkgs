{
  mkKdeDerivation,
  qttools,
  qtmultimedia,
  qt5compat,
}:
mkKdeDerivation {
  pname = "konversation";

  extraBuildInputs = [ qt5compat ];
  extraNativeBuildInputs = [
    qtmultimedia
    qttools
  ];

  meta.mainProgram = "konversation";
}
