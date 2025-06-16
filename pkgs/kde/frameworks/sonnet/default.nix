{
  mkKdeDerivation,
  qtdeclarative,
  pkg-config,
  aspell,
  hunspell,
}:
mkKdeDerivation {
  pname = "sonnet";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtdeclarative
    aspell
    hunspell
  ];
  meta.mainProgram = "parsetrigrams6";
}
