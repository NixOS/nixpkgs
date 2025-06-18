{
  mkKdeDerivation,
  qtmultimedia,
  qt5compat,
}:
mkKdeDerivation {
  pname = "konversation";

  extraBuildInputs = [ qt5compat ];
  extraNativeBuildInputs = [ qtmultimedia ];

  meta.mainProgram = "konversation";
}
