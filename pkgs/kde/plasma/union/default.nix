{
  mkKdeDerivation,
  kcoreaddons,
}:
mkKdeDerivation {
  pname = "union";

  extraBuildInputs = [
    kcoreaddons
  ];
}
