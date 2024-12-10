{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kcachegrind";

  extraNativeBuildInputs = [ qttools ];
}
