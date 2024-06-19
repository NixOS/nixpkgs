{
  mkKdeDerivation,
  qtsvg,
  qtcharts,
  qqc2-desktop-style,
  kholidays,
}:
mkKdeDerivation {
  pname = "kweather";

  extraBuildInputs = [qtsvg qtcharts qqc2-desktop-style kholidays];
  meta.mainProgram = "kweather";
}
