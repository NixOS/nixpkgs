{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kstatusnotifieritem";

  extraNativeBuildInputs = [ qttools ];
}
