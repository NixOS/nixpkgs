{
  mkKdeDerivation,
  plasma-activities-stats,
}:
mkKdeDerivation {
  pname = "sweeper";

  extraBuildInputs = [plasma-activities-stats];
}
