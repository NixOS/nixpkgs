{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcmutils";

  extraPropagatedBuildInputs = [ qtdeclarative ];

  postInstall = ''
    generateQmlStubs org.kde.kcmutils 1.0
  '';

  meta.mainProgram = "kcmshell6";
}
