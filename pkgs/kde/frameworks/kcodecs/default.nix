{
  mkKdeDerivation,
  gperf,
}:
mkKdeDerivation {
  pname = "kcodecs";

  extraNativeBuildInputs = [
    gperf
  ];
}
