{
  lib,
  mkKdeDerivation,
  qttools,
  graphviz,
}:
mkKdeDerivation {
  pname = "kcachegrind";

  extraNativeBuildInputs = [ qttools ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ graphviz ]}"
  ];
}
