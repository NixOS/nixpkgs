{
  mkKdeDerivation,
  qtdeclarative,
  perl,
}:
mkKdeDerivation {
  pname = "syntax-highlighting";

  extraBuildInputs = [ qtdeclarative ];
  extraNativeBuildInputs = [ perl ];
  meta.mainProgram = "ksyntaxhighlighter6";
}
