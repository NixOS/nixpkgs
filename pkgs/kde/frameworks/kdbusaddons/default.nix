{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kdbusaddons";

  extraNativeBuildInputs = [qttools];
}
