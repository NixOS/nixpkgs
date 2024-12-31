{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "libkdepim";

  extraNativeBuildInputs = [qttools];
}
