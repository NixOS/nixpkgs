{
  mkKdeDerivation,
  qtsvg,
  qtcharts,
  kholidays,
}:
mkKdeDerivation {
  pname = "kweather";

  extraBuildInputs = [
    qtsvg
    qtcharts
    kholidays
  ];
  meta.mainProgram = "kweather";
}
