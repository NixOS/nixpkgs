{
  mkKdeDerivation,
  qttools,
  ki18n,
}:
mkKdeDerivation {
  pname = "kmime";

  extraNativeBuildInputs = [ qttools ];
  extraBuildInputs = [ ki18n ];
}
