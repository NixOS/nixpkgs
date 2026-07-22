{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kmime";

  extraNativeBuildInputs = [ qttools ];
}
