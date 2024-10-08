{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kglobalaccel";

  extraNativeBuildInputs = [ qttools ];
}
