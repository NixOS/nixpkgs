{
  mkKdeDerivation,
  qttools,
  cyrus-sasl,
}:
mkKdeDerivation {
  pname = "libkgapi";

  extraBuildInputs = [
    qttools
    cyrus-sasl
  ];
}
