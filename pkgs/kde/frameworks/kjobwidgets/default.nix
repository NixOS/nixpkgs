{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kjobwidgets";

  extraNativeBuildInputs = [ qttools ];
}
