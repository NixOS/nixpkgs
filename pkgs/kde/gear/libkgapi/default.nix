{
  mkKdeDerivation,
  qttools,
  cyrus_sasl,
}:
mkKdeDerivation {
  pname = "libkgapi";

  extraBuildInputs = [qttools cyrus_sasl];
}
