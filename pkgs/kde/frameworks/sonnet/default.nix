{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  pkg-config,
  aspell,
  hunspell,
}:
mkKdeDerivation {
  pname = "sonnet";

  extraNativeBuildInputs = [
    qttools
    pkg-config
  ];
  extraBuildInputs = [
    qtdeclarative
    aspell
    hunspell
  ];
  meta.mainProgram = "parsetrigrams6";
}
