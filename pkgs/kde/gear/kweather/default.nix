{
  mkKdeDerivation,
  qtsvg,
  qtcharts,
  kholidays,
}:
mkKdeDerivation {
  pname = "kweather";

  extraNativeBuildInputs = [ qtcharts ];

  extraBuildInputs = [
    qtsvg
    qtcharts
    kholidays
  ];

  meta.mainProgram = "kweather";
}
