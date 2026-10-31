{
  lib,
  mkKdeDerivation,
  qttools,
  graphviz,
}:
mkKdeDerivation {
  pname = "kcachegrind";

  __structuredAttrs = true;

  extraNativeBuildInputs = [ qttools ];

  qtWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ graphviz ])
  ];
}
