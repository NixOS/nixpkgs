{
  mkKdeDerivation,
  qtdeclarative,
  spirv-tools,
}:
mkKdeDerivation {
  pname = "kdeclarative";

  extraNativeBuildInputs = [spirv-tools];
  extraBuildInputs = [qtdeclarative];
}
