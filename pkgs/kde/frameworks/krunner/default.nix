{
  mkKdeDerivation,
  plasma-activities,
}:
mkKdeDerivation {
  pname = "krunner";

  extraBuildInputs = [ plasma-activities ];
}
