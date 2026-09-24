{
  mkKdeDerivation,
  kquickcharts,
}:
mkKdeDerivation {
  pname = "plasma-systemmonitor";

  extraPropagatedBuildInputs = [ kquickcharts ];

  meta.mainProgram = "plasma-systemmonitor";
}
