{
  mkKdeDerivation,
  qtsvg,
  qttools,
}:
mkKdeDerivation {
  pname = "kirigami-gallery";

  extraNativeBuildInputs = [qtsvg qttools];
}
