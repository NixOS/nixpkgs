{
  mkKdeDerivation,
  qtsvg,
  qttools,
}:
mkKdeDerivation {
  pname = "kirigami-gallery";

  extraNativeBuildInputs = [
    qtsvg
    qttools
  ];

  meta.mainProgram = "kirigami2gallery";
}
