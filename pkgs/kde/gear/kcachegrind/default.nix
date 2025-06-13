{
  lib,
  mkKdeDerivation,
  graphviz,
}:
mkKdeDerivation {
  pname = "kcachegrind";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ graphviz ]}"
  ];
}
