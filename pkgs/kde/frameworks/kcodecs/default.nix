{
  mkKdeDerivation,
  qttools,
  gperf,
}:
mkKdeDerivation {
  pname = "kcodecs";

  extraNativeBuildInputs = [qttools gperf];
}
