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
    kholidays
  ];

  meta.mainProgram = "kweather";
}
